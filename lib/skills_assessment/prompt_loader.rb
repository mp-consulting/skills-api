# lib/prompt_loader.rb
require 'pathname'

module SkillsAssessment
  class PromptLoader
    def self.load(skill_type)
      # Convert symbol to string if needed
      skill_type = skill_type.to_s if skill_type.is_a?(Symbol)

      # Convert underscores to hyphens for file naming
      file_name = skill_type.gsub('_', '-') + '-assessment.md'
      file_path = prompts_dir.join(file_name)
      return nil unless file_path.exist?

      content = file_path.read
      extract_template(content)
    end

    def self.load_search_query_template
      file_path = prompts_dir.join('search-query-generation.md')
      return nil unless file_path.exist?

      content = file_path.read
      extract_template(content)
    end

    def self.load_web_analysis_template
      file_path = prompts_dir.join('web-search-analysis.md')
      return nil unless file_path.exist?

      content = file_path.read
      extract_template(content)
    end

    def self.load_web_research_template
      file_path = prompts_dir.join('web-research-assessment.md')
      return nil unless file_path.exist?

      content = file_path.read
      extract_template(content)
    end

    def self.prompts_dir
      Pathname.new(__dir__).join('prompts')
    end
    private_class_method :prompts_dir

    def self.extract_template(content)
      # Remove frontmatter if present (between --- markers)
      content = content.gsub(/^---.*?---\n/m, '')

      # Extract content between "## Prompt Template" and the next section
      if content =~ /## Prompt Template\n(.*?)(?=\n##|\n## Parameters|\n## Expected|\n## Usage|\z)/m
        content = ::Regexp.last_match(1).strip
      end

      # Remove markdown code block markers but keep content
      content = content.gsub(/```\w*\n?/, '')

      # Fix Ruby string interpolation syntax: {variable} -> %{variable}
      # Only convert braces that don't already have % in front
      content = content.gsub(/(?<!%)(\{)(\w+)(\})/, '%{\2}')

      # Clean up extra whitespace and empty lines
      content = content.split("\n").map(&:strip).reject(&:empty?).join("\n")

      content.strip
    end
    private_class_method :extract_template
  end
end
