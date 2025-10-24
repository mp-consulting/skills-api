#!/usr/bin/env ruby
# cli.rb - Thor-based CLI for CV Skills Analyzer

require 'thor'
require 'dotenv'
Dotenv.load

require 'json'
require 'base64'
require 'erb'

# Load all classes via Zeitwerk (no manual requires needed)
require_relative 'config/zeitwerk'

class SkillsAssessmentCLI < Thor
  desc 'analyze ROLE CV_FILE', 'Analyze CV for a specific role'
  option :output, aliases: '-o', desc: 'Output file path (.json or .html)'
  option :logging, aliases: '-l', type: :boolean, default: false, desc: 'Enable LLM logging'

  def analyze(role, cv_file)
    # Validate role
    unless SkillsAssessment::RoleConfig.valid?(role)
      say "❌ Error: Invalid role '#{role}'", :red
      say "Valid roles: #{SkillsAssessment::RoleConfig.valid_roles.join(', ')}", :yellow
      exit 1
    end

    # Validate CV file
    unless File.exist?(cv_file)
      say "❌ Error: CV file '#{cv_file}' not found", :red
      exit 1
    end

    # Set logging ENV if requested
    ENV['LLM_LOGGING'] = 'true' if options[:logging]

    # Validate API key
    api_key = ENV['ANTHROPIC_API_KEY']
    if api_key.nil? || api_key.empty?
      say '❌ Error: ANTHROPIC_API_KEY environment variable not set', :red
      say 'Add your key to the .env file:', :yellow
      say 'ANTHROPIC_API_KEY=your-key-here'
      exit 1
    end

    # Get configuration
    config = SkillsAssessment::RoleConfig.for(role)

    # Determine output path
    output_path = determine_output_path(options[:output], role, cv_file)

    # Analyze CV
    say "📄 Loading CV: #{cv_file}", :cyan
    say "🔍 Analyzing for role: #{role}", :cyan

    response = analyze_cv(role, cv_file, api_key, config)

    # Clean and parse response
    say '🔍 Parsing assessment results...', :cyan
    cleaner = SkillsAssessment::ResponseCleaner.new
    cleaned = cleaner.clean(response)

    begin
      assessment = JSON.parse(cleaned)

      # Display formatted output
      format_and_display(assessment, config)

      # Save to file
      if output_path
        say ''
        output_format = output_path.end_with?('.html') ? :html : :json

        if output_format == :html
          html_content = generate_html_report(assessment, config, File.basename(cv_file))
          File.write(output_path, html_content)
          say "🌐 Interactive HTML report saved to: #{output_path}", :green
        else
          File.write(output_path, JSON.pretty_generate(assessment))
          say "💾 Assessment saved to: #{output_path}", :green
        end
      end
    rescue JSON::ParserError => e
      say '❌ Error: Failed to parse LLM response as JSON', :red
      say "Error: #{e.message}", :red
      exit 1
    end
  end

  desc 'identify-roles CV_FILE', 'Identify relevant roles from CV'
  option :output, aliases: '-o', desc: 'Output file path for JSON results'
  option :logging, aliases: '-l', type: :boolean, default: false, desc: 'Enable LLM logging'

  def identify_roles(cv_file)
    # Validate CV file
    unless File.exist?(cv_file)
      say "❌ Error: CV file '#{cv_file}' not found", :red
      exit 1
    end

    # Set logging ENV if requested
    ENV['LLM_LOGGING'] = 'true' if options[:logging]

    # Validate API key
    api_key = ENV['ANTHROPIC_API_KEY']
    if api_key.nil? || api_key.empty?
      say '❌ Error: ANTHROPIC_API_KEY environment variable not set', :red
      say 'Add your key to the .env file:', :yellow
      say 'ANTHROPIC_API_KEY=your-key-here'
      exit 1
    end

    # Identify roles
    say "📄 Loading CV: #{cv_file}", :cyan
    say "🔍 Analyzing CV to identify relevant roles...", :cyan
    say '⏳ This may take a moment...', :yellow

    identifier = SkillsAssessment::RoleIdentifier.new(cv_file, api_key: api_key)

    begin
      result = identifier.identify_roles

      # Display results
      say ''
      say '=' * 80, :blue
      say 'Role Identification Results', :blue
      say '=' * 80, :blue

      # Display summary
      say "\n📋 Career Summary:", :cyan
      say result['summary'], :white

      # Display primary role
      say "\n🎯 Primary Role Match:", :green
      say "#{result['primary_role']}", :green

      # Display identified roles
      if result['identified_roles'].any?
        say "\n✅ Identified Roles:", :green
        result['identified_roles'].each do |role_data|
          confidence_pct = (role_data['confidence'] * 100).round(1)
          confidence_color = if role_data['confidence'] >= 0.85
                               :green
                             elsif role_data['confidence'] >= 0.75
                               :yellow
                             else
                               :cyan
                             end

          say "  • #{role_data['role']} (#{confidence_pct}%)", confidence_color
          say "    #{role_data['justification']}", :white
          if role_data['key_evidence'] && role_data['key_evidence'].any?
            say "    Evidence: #{role_data['key_evidence'].join(', ')}", :cyan
          end
        end
      else
        say "\n⚠️  No matching roles identified", :yellow
      end

      # Save to file if requested
      if options[:output]
        output_path = options[:output]
        output_path = File.join('reports', output_path) if !output_path.include?('/') && !output_path.include?('\\')

        Dir.mkdir('reports') unless Dir.exist?('reports')
        File.write(output_path, JSON.pretty_generate(result))

        say "\n💾 Results saved to: #{output_path}", :green
      end

      say ''
    rescue StandardError => e
      say "❌ Error: Failed to identify roles", :red
      say "Error: #{e.message}", :red
      exit 1
    end
  end

  private

  def determine_output_path(output_option, role, cv_file)
    return nil unless output_option

    # If output path is just a filename, put it in reports folder
    if !output_option.include?('/') && !output_option.include?('\\')
      reports_dir = 'reports'
      Dir.mkdir(reports_dir) unless Dir.exist?(reports_dir)
      return File.join(reports_dir, output_option)
    end

    output_option
  end

  def prepare_prompt(role, config)
    template = SkillsAssessment::PromptLoader.load(config[:prompt_key])
    if template.nil?
      say "❌ Error: Could not load #{role} skills assessment prompt", :red
      exit 1
    end

    esco_skills = load_esco_skills(role)

    # Use format() with %{variable} syntax - always include esco_skills in case template uses it
    format(template, cv_text: '[CV content will be provided as PDF attachment]', esco_skills: esco_skills)
  end

  def load_esco_skills(role)
    esco_file = case role
                when 'data-scientist'
                  'lib/skills_assessment/ESCO/data-scientist-skills.csv'
                when 'it-manager'
                  'lib/skills_assessment/ESCO/it-manager-skills.csv'
                when 'software-architect'
                  'lib/skills_assessment/ESCO/software-architect-skills.csv'
                else
                  nil
                end

    return '' unless esco_file && File.exist?(esco_file)

    lines = File.readlines(esco_file)
    essential_skills = []
    optional_skills = []

    lines.each_with_index do |line, index|
      next if index == 0

      parts = line.strip.split(',', 2)
      next if parts.length < 2

      skill = parts[1].strip.gsub('"', '')
      if index <= 50
        essential_skills << skill
      else
        optional_skills << skill
      end
    end

    skills_text = "ESSENTIAL SKILLS:\n"
    essential_skills.each { |s| skills_text += "- #{s}\n" }
    skills_text += "\nOPTIONAL SKILLS:\n"
    optional_skills.each { |s| skills_text += "- #{s}\n" }
    skills_text
  end

  def analyze_cv(role, cv_path, api_key, config)
    prompt = prepare_prompt(role, config)
    client = SkillsAssessment::LLMClient.new(api_key)

    say '🚀 Sending CV to Claude for OCR and analysis...', :cyan
    say '⏳ This may take a moment...', :yellow

    client.call_with_pdf(prompt, cv_path, config[:max_tokens])
  end

  def format_and_display(assessment, config)
    say ''
    say '=' * 80, :blue
    say config[:title], :blue
    say '=' * 80, :blue

    # Display overall score
    overall = assessment['overall_readiness']
    score = overall&.dig('score') || 'N/A'
    summary = overall&.dig('summary') || 'No summary available'

    score_color = if score.to_i >= 8
                    :green
                  else
                    (score.to_i >= 6 ? :yellow : :red)
                  end
    say "\n📊 Overall Score: #{score}/10", score_color
    say "📝 Summary: #{summary}", :cyan

    # Display identified skills
    identified = assessment['identified_skills'] || []
    if identified.any?
      say "\n✅ Identified Skills (#{identified.length}):", :green
      identified.each do |skill|
        level = skill['proficiency_level'] || 'N/A'
        confidence = skill['confidence_score'] ? (skill['confidence_score'] * 100).to_i : 0
        say "  • #{skill['skill_name']} - Level: #{level}/10, Confidence: #{confidence}%", :cyan
      end
    end

    # Display missing essential skills
    missing = assessment['missing_essential_skills'] || []
    if missing.any?
      say "\n⚠️  Missing Essential Skills (#{missing.length}):", :yellow
      missing.each { |skill| say "  ○ #{skill}", :yellow }
    end

    say ''
  end

  def generate_html_report(assessment, config, cv_filename)
    generator = SkillsAssessment::HtmlReportGenerator.new(assessment, config, cv_filename)
    generator.generate
  end
end

# Run CLI
SkillsAssessmentCLI.start(ARGV)
