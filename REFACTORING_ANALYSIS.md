# Ruby Code Refactoring Analysis - Skills API

This document provides a comprehensive refactoring analysis following Clean Code, SOLID principles, Sandi Metz's Rules, and Ruby community standards.

---

## 1. CLI.rb - Method Length & Complexity Issues

### Issue 1.1: `analyze` method too long and doing too much (SRP violation)

**Problem**: The `analyze` method is 52 lines and handles validation, configuration, analysis, parsing, display, and file output—violating Single Responsibility Principle and Sandi Metz's rule of methods under 10 lines.

**Before**:
```ruby
def analyze(role, cv_file)
  # Validate role
  valid_roles = %w[data-scientist it-manager software-architect]
  unless valid_roles.include?(role)
    say "❌ Error: Invalid role '#{role}'", :red
    say "Valid roles: #{valid_roles.join(', ')}", :yellow
    exit 1
  end

  # Validate CV file
  unless File.exist?(cv_file)
    say "❌ Error: CV file '#{cv_file}' not found", :red
    exit 1
  end

  # ... (44+ more lines)
end
```

**After - Extract to Service Objects**:
```ruby
def analyze(role, cv_file)
  validate_inputs(role, cv_file)
  config = get_role_config(role)
  output_path = determine_output_path(options[:output], role, cv_file)

  assessment = perform_analysis(role, cv_file, config)
  format_and_display(assessment, config)
  save_output(assessment, config, output_path, cv_file) if output_path
rescue StandardError => e
  handle_analysis_error(e)
end

private

def validate_inputs(role, cv_file)
  validate_role(role)
  validate_cv_file(cv_file)
  validate_api_key
end

def validate_role(role)
  return if valid_roles.include?(role)
  say "❌ Error: Invalid role '#{role}'", :red
  say "Valid roles: #{valid_roles.join(', ')}", :yellow
  exit 1
end

def validate_cv_file(cv_file)
  return if File.exist?(cv_file)
  say "❌ Error: CV file '#{cv_file}' not found", :red
  exit 1
end

def validate_api_key
  return if ENV['ANTHROPIC_API_KEY']&.present?
  say '❌ Error: ANTHROPIC_API_KEY environment variable not set', :red
  say 'Add your key to the .env file:', :yellow
  say 'ANTHROPIC_API_KEY=your-key-here'
  exit 1
end

def perform_analysis(role, cv_file, config)
  say "📄 Loading CV: #{cv_file}", :cyan
  say "🔍 Analyzing for role: #{role}", :cyan
  
  response = analyze_cv(role, cv_file, ENV['ANTHROPIC_API_KEY'], config)
  cleaner = SkillsAssessment::ResponseCleaner.new
  cleaner.clean(response)
  JSON.parse(cleaner.clean(response))
rescue JSON::ParserError => e
  handle_json_parse_error(e)
end

def save_output(assessment, config, output_path, cv_filename)
  output_format = output_path.end_with?('.html') ? :html : :json
  
  case output_format
  when :html
    html_content = generate_html_report(assessment, config, File.basename(cv_filename))
    File.write(output_path, html_content)
    say "🌐 Interactive HTML report saved to: #{output_path}", :green
  when :json
    File.write(output_path, JSON.pretty_generate(assessment))
    say "💾 Assessment saved to: #{output_path}", :green
  end
end
```

**Explanation**: 
- Breaks down the massive method into focused, single-responsibility methods
- Each method now does ONE thing
- Makes error handling explicit and testable
- Improves readability and maintainability

**Principles Applied**: SRP, Sandi Metz's rule (methods < 10 lines), KISS

---

### Issue 1.2: Configuration stored in hash (should use Config object)

**Problem**: Role configuration is hardcoded as a hash inside the method, making it unmaintainable and violating DRY.

**Before**:
```ruby
def get_role_config(role)
  configs = {
    'data-scientist' => {
      prompt_key: 'data_scientist_skills',
      max_tokens: 3000,
      title: 'DATA SCIENTIST SKILLS ASSESSMENT'
    },
    # ... more roles
  }
  configs[role]
end
```

**After - Create Config Object**:
```ruby
# lib/skills_assessment/role_config.rb
module SkillsAssessment
  class RoleConfig
    CONFIGS = {
      'data-scientist' => {
        prompt_key: 'data_scientist_skills',
        max_tokens: 3000,
        title: 'DATA SCIENTIST SKILLS ASSESSMENT'
      },
      'it-manager' => {
        prompt_key: 'it_manager_skills',
        max_tokens: 4000,
        title: 'IT MANAGER SKILLS ASSESSMENT'
      },
      'software-architect' => {
        prompt_key: 'software_architect_skills',
        max_tokens: 4000,
        title: 'SOFTWARE ARCHITECT SKILLS ASSESSMENT'
      }
    }.freeze

    def self.for(role)
      CONFIGS[role] || raise ConfigError, "Unknown role: #{role}"
    end

    class ConfigError < StandardError; end
  end
end
```

**CLI Usage**:
```ruby
def get_role_config(role)
  SkillsAssessment::RoleConfig.for(role)
end
```

**Explanation**: 
- Centralizes configuration, making it maintainable
- Raises explicit error for invalid roles
- Easier to add new roles
- Separates concerns

**Principles Applied**: DRY, Single Responsibility, Maintainability

---

### Issue 1.3: ESCO skills loading hardcoded with repetition

**Problem**: The `load_esco_skills` method has repetitive case statement for file paths and duplicated list building logic.

**Before**:
```ruby
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

  # ... string building
end
```

**After - Query Object Pattern**:
```ruby
# lib/skills_assessment/esco_skills_loader.rb
module SkillsAssessment
  class ESCOSkillsLoader
    SKILLS_DIR = 'lib/skills_assessment/ESCO'
    ESSENTIAL_THRESHOLD = 50

    def self.load(role)
      new(role).load
    end

    def initialize(role)
      @role = role
    end

    def load
      return '' unless esco_file.exist?
      format_skills_text(parse_csv)
    end

    private

    def esco_file
      @esco_file ||= Pathname.new(File.join(SKILLS_DIR, "#{@role}-skills.csv"))
    end

    def parse_csv
      File.readlines(esco_file).drop(1).each_with_object(
        { essential: [], optional: [] }
      ) { |line, acc| add_skill(line, acc) }
    end

    def add_skill(line, accumulator)
      parts = line.strip.split(',', 2)
      return unless parts.length == 2
      
      skill = parts[1].strip.delete('"')
      index = File.readlines(esco_file).index(line)
      
      category = index <= ESSENTIAL_THRESHOLD ? :essential : :optional
      accumulator[category] << skill
    end

    def format_skills_text(skills)
      text = "ESSENTIAL SKILLS:\n"
      text += skills[:essential].map { |s| "- #{s}\n" }.join
      text += "\nOPTIONAL SKILLS:\n"
      text += skills[:optional].map { |s| "- #{s}\n" }.join
      text
    end
  end
end
```

**CLI Usage**:
```ruby
def load_esco_skills(role)
  SkillsAssessment::ESCOSkillsLoader.load(role)
end
```

**Explanation**:
- Eliminates repetitive case statement
- Separates CSV parsing from formatting
- Uses Query Object pattern
- More testable and maintainable
- Easy to swap CSV loader implementation

**Principles Applied**: DRY, Single Responsibility, Query Object Pattern, Composition

---

### Issue 1.4: Magic numbers and hardcoded values

**Problem**: Output format detection uses string literals; role validation repeats valid roles list.

**Before**:
```ruby
valid_roles = %w[data-scientist it-manager software-architect]
unless valid_roles.include?(role)
  # ...
end

output_format = output_path.end_with?('.html') ? :html : :json
```

**After**:
```ruby
# lib/skills_assessment/constants.rb
module SkillsAssessment
  module Constants
    VALID_ROLES = %w[data-scientist it-manager software-architect].freeze
    OUTPUT_FORMATS = { html: '.html', json: '.json' }.freeze
  end
end

# cli.rb
def validate_role(role)
  return if Constants::VALID_ROLES.include?(role)
  # ...
end

def determine_output_format(path)
  OUTPUT_FORMATS.key(File.extname(path))&.to_s || 'json'
end
```

**Explanation**:
- Centralized configuration management
- Frozen constants prevent accidental mutation
- Easy to maintain and extend
- Better semantics

**Principles Applied**: DRY, Constants Management, Immutability

---

## 2. HtmlReportGenerator - God Object & String Building Issues

### Issue 2.1: Too many rendering methods (God Object - violates SRP)

**Problem**: `HtmlReportGenerator` has 10+ rendering methods, each building HTML strings manually—violates SRP.

**Before**:
```ruby
class HtmlReportGenerator
  # ... 10+ render_*_html methods that build strings manually
  
  def render_skills_html
    html = ''
    skills_by_category.each do |category, skills|
      html += "    <h3 class=\"category-title\">#{category}</h3>\n"
      html += "    <table class=\"skills-table\">\n"
      # ... 20+ lines of string concatenation
    end
    html
  end

  def render_essential_skills_html
    skills = @assessment['essential_skills_found'] || []
    return '' unless skills.any?
    html = "    <div class=\"skills-list found-skills\">\n"
    skills.each do |skill|
      html += "      <div class=\"skill-item found\"><span class=\"skill-icon\">✓</span> #{skill}</div>\n"
    end
    html += "    </div>\n"
    html
  end
  # ... more of the same
end
```

**After - Use Presenters & Partials**:
```ruby
# lib/skills_assessment/html_report_generator.rb
module SkillsAssessment
  class HtmlReportGenerator
    def initialize(assessment, config, cv_filename)
      @assessment = assessment
      @config = config
      @cv_filename = cv_filename
    end

    def generate
      presenter = ReportPresenter.new(@assessment, @config, @cv_filename)
      ERB.new(load_template).result(presenter.get_binding)
    end

    private

    def load_template
      template_path = Pathname.new(__dir__).join('templates', 'report.html.erb')
      File.read(template_path)
    end
  end
end

# lib/skills_assessment/presenters/report_presenter.rb
module SkillsAssessment::Presenters
  class ReportPresenter
    def initialize(assessment, config, cv_filename)
      @assessment = assessment
      @config = config
      @cv_filename = cv_filename
    end

    def get_binding
      binding
    end

    # Simple accessor methods only - no HTML building
    delegate :score, :summary, to: :readiness_presenter
    delegate :title, to: :config_presenter
    
    def skills_presenter
      @skills_presenter ||= SkillsPresenter.new(@assessment)
    end

    def essential_skills_presenter
      @essential_skills_presenter ||= EssentialSkillsPresenter.new(@assessment)
    end

    def readiness_presenter
      @readiness_presenter ||= ReadinessPresenter.new(@assessment)
    end

    private

    def config_presenter
      ConfigPresenter.new(@config)
    end
  end
end

# lib/skills_assessment/presenters/skills_presenter.rb
module SkillsAssessment::Presenters
  class SkillsPresenter
    def initialize(assessment)
      @skills = assessment['identified_skills'] || []
    end

    def any?
      @skills.any?
    end

    def by_category
      @skills.group_by { |s| s['skill_category'] }
    end

    def skills_for(category)
      by_category[category]
    end
  end
end
```

**Template Usage** (report.html.erb):
```erb
<% if skills_presenter.any? %>
  <div class="section">
    <h2>🎯 Identified Skills</h2>
    <% skills_presenter.by_category.each do |category, skills| %>
      <%= render 'skills_table', category: category, skills: skills %>
    <% end %>
  </div>
<% end %>
```

**Explanation**:
- Separates data presentation from logic
- Uses Presenter pattern for domain logic
- Templates handle only HTML rendering
- Each presenter has single responsibility
- Easier to test

**Principles Applied**: SRP, Presenter Pattern, DRY, Composition

---

### Issue 2.2: Repetitive predicate methods

**Problem**: 8 similar `has_*?` methods checking if collections are non-empty.

**Before**:
```ruby
def has_strengths?
  @readiness['strengths']&.any? || false
end

def has_development_areas?
  @readiness['development_areas']&.any? || false
end

def has_identified_skills?
  @assessment['identified_skills']&.any? || false
end

def has_essential_skills?
  @assessment['essential_skills_found']&.any? || false
end

def has_optional_skills?
  @assessment['optional_skills_found']&.any? || false
end

def has_missing_skills?
  @assessment['missing_essential_skills']&.any? || false
end
```

**After - Use Dynamic Dispatch**:
```ruby
SKILL_SECTIONS = {
  strengths: [:readiness, 'strengths'],
  development_areas: [:readiness, 'development_areas'],
  identified_skills: [:assessment, 'identified_skills'],
  essential_skills: [:assessment, 'essential_skills_found'],
  optional_skills: [:assessment, 'optional_skills_found'],
  missing_skills: [:assessment, 'missing_essential_skills']
}.freeze

def method_missing(method_name, *args)
  if method_name.to_s.start_with?('has_') && method_name.to_s.end_with?('?')
    key = method_name.to_s.gsub(/^has_|_\?$/, '').to_sym
    return false unless SKILL_SECTIONS.key?(key)
    
    source, path = SKILL_SECTIONS[key]
    source_data = source == :readiness ? @readiness : @assessment
    source_data[path]&.any? || false
  else
    super
  end
end

def respond_to_missing?(method_name, include_private = false)
  return true if method_name.to_s.start_with?('has_') && method_name.to_s.end_with?('?')
  super
end
```

**Explanation**:
- Eliminates repetitive code
- Uses metaprogramming appropriately
- Centralizes skill section definitions
- Easier to maintain
- Reduces code duplication

**Principles Applied**: DRY, KISS, Ruby idioms

---

### Issue 2.3: String concatenation for HTML (inefficient)

**Problem**: Building HTML strings with `+=` operator is inefficient and hard to read.

**Before**:
```ruby
def render_skills_html
  html = ''
  skills.each do |skill|
    html += "    <tr class=\"#{row_class}\">\n"
    html += "          <td class=\"skill-name-cell\"><strong>#{skill['skill_name']}</strong></td>\n"
    # ... more lines
  end
  html
end
```

**After - Use Array & Join**:
```ruby
def render_skills_html
  skills.map { |skill| render_skill_row(skill) }.join("\n")
end

private

def render_skill_row(skill)
  level = skill['proficiency_level'].to_i
  confidence = (skill['confidence_score'].to_f * 100).round
  evidence = skill['evidence'] || 'No evidence provided'
  
  [
    "<tr class=\"#{row_class(skill)}\">",
    "<td class=\"skill-name-cell\"><strong>#{h(skill['skill_name'])}</strong></td>",
    "<td class=\"skill-level-cell\">#{level}/10</td>",
    "<td class=\"skill-confidence-cell\">#{confidence}%</td>",
    "<td class=\"skill-bar-cell\">#{render_proficiency_bar(level)}</td>",
    "<td class=\"skill-evidence-cell\"><em>#{h(evidence)}</em></td>",
    "</tr>"
  ].join("\n")
end

def h(string)
  ERB::Util.html_escape(string)
end
```

**Explanation**:
- Faster than string concatenation
- More readable with array structure
- Easier to debug
- Includes HTML escaping for security

**Principles Applied**: Performance, Readability, Security (XSS prevention)

---

## 3. LLMClient - Multiple Responsibilities & Code Duplication

### Issue 3.1: Two nearly identical logging methods

**Problem**: `log_raw_response` and `log_raw_response_from_hash` are duplicated logic.

**Before**:
```ruby
def log_raw_response(response, prompt, max_tokens, pdf_path = nil)
  # ~20 lines of logging setup
end

def log_raw_response_from_hash(response_hash, prompt, max_tokens, pdf_path = nil)
  # ~20 lines of nearly identical code
end
```

**After - Extract to Separate Class**:
```ruby
# lib/skills_assessment/llm_response_logger.rb
module SkillsAssessment
  class LLMResponseLogger
    def self.log(response, prompt, max_tokens, pdf_path = nil)
      new(response, prompt, max_tokens, pdf_path).log if ENV['LLM_LOGGING'] == 'true'
    end

    def initialize(response, prompt, max_tokens, pdf_path)
      @response = response
      @prompt = prompt
      @max_tokens = max_tokens
      @pdf_path = pdf_path
    end

    def log
      File.write(log_file_path, JSON.pretty_generate(log_data))
      puts "🔍 LLM response logged to: #{log_file_path}"
    rescue => e
      warn "⚠️ Failed to log LLM response: #{e.message}"
    end

    private

    def log_data
      {
        timestamp: Time.now.iso8601,
        model: Constants::LLM_MODEL,
        max_tokens: @max_tokens,
        temperature: Constants::LLM_TEMPERATURE,
        prompt_preview: @prompt[0..200] + (@prompt.length > 200 ? "..." : ""),
        pdf_file: @pdf_path ? File.basename(@pdf_path) : nil,
        raw_response: @response,
        success: !@response.nil?
      }
    end

    def log_file_path
      logs_dir = File.join(Dir.pwd, "logs", "llm")
      FileUtils.mkdir_p(logs_dir)
      
      timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
      File.join(logs_dir, "llm_response_#{timestamp}.json")
    end
  end
end

# In LLMClient
def call_with_pdf(prompt, pdf_path, max_tokens = Constants::DEFAULT_MAX_TOKENS)
  # ... API call logic
  
  response_hash = JSON.parse(response.body)
  LLMResponseLogger.log(response_hash, prompt, max_tokens, pdf_path)
  
  response_hash['content']&.first&.dig('text')
end
```

**Explanation**:
- Eliminates duplication
- Logging is now a separate concern
- Easier to test
- Can be reused elsewhere

**Principles Applied**: SRP, DRY, Composition

---

### Issue 3.2: Magic strings for API configuration

**Problem**: Hard-coded API version, model name, and endpoint scattered throughout.

**Before**:
```ruby
request['anthropic-version'] = '2023-06-01'
payload = { model: "claude-sonnet-4-5-20250929", ... }
uri = URI('https://api.anthropic.com/v1/messages')
```

**After - Centralize Configuration**:
```ruby
# lib/skills_assessment/constants.rb
module SkillsAssessment
  module Constants
    # API Configuration
    ANTHROPIC_BASE_URL = 'https://api.anthropic.com'
    ANTHROPIC_API_VERSION = '2023-06-01'
    LLM_MODEL = 'claude-sonnet-4-5-20250929'
    LLM_TEMPERATURE = 0.1
    DEFAULT_MAX_TOKENS = 2000
  end
end

# In LLMClient
def call_with_pdf(prompt, pdf_path, max_tokens = Constants::DEFAULT_MAX_TOKENS)
  payload = {
    model: Constants::LLM_MODEL,
    max_tokens: max_tokens,
    temperature: Constants::LLM_TEMPERATURE,
    messages: [{ role: "user", content: build_content(prompt, pdf_path) }]
  }

  response = make_api_request(payload)
  
  response.code.to_i == 200 ? parse_response(response) : handle_error(response)
end

private

def make_api_request(payload)
  uri = build_uri
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = build_request(uri, payload)
  http.request(request)
end

def build_uri
  URI("#{Constants::ANTHROPIC_BASE_URL}/v1/messages")
end

def build_request(uri, payload)
  request = Net::HTTP::Post.new(uri.path)
  request['anthropic-version'] = Constants::ANTHROPIC_API_VERSION
  request['content-type'] = 'application/json'
  request['x-api-key'] = @api_key
  request.body = payload.to_json
  request
end
```

**Explanation**:
- Centralizes API configuration
- Easy to update API version or model
- Reduces magic strings
- Better for maintainability

**Principles Applied**: DRY, Constants Management, Maintainability

---

## 4. ResponseCleaner - Regex Complexity & Long Method

### Issue 4.1: Complex regex patterns and long method

**Problem**: The `clean` method is 20+ lines with complex regex logic that's hard to understand and test.

**Before**:
```ruby
def clean(response)
  response = response.to_s if response
  return "" unless response.is_a?(String) && !response.empty?

  json_match = response.match(/```(?:json)?\s*(\{.*\}|\[.*\])\s*```/m)
  return json_match[1] if json_match

  cleaned = response
    .gsub(/```json\s*/, '')
    .gsub(/```\s*$/, '')
    .gsub(/^#+\s+.*\n/, '')
    # ... 10+ more regex patterns
    .strip

  # ... json extraction logic
  repair_incomplete_json(cleaned)
  cleaned.strip
end
```

**After - Separate Concerns into Strategies**:
```ruby
# lib/skills_assessment/response_cleaner.rb
module SkillsAssessment
  class ResponseCleaner
    STRATEGIES = [
      JsonCodeBlockStrategy,
      JsonExtractionStrategy,
      MarkdownRemovalStrategy,
      JsonRepairStrategy
    ].freeze

    def clean(response)
      normalized = normalize_input(response)
      return "" if normalized.empty?

      STRATEGIES.each do |strategy_class|
        result = strategy_class.apply(normalized)
        return result if result.present?
      end

      normalized
    end

    private

    def normalize_input(response)
      response.to_s.strip
    end
  end
end

# lib/skills_assessment/cleaning_strategies/json_code_block_strategy.rb
module SkillsAssessment::CleaningStrategies
  class JsonCodeBlockStrategy
    # Extract JSON from ```json { ... } ``` blocks
    CODE_BLOCK_PATTERN = /```(?:json)?\s*(\{.*\}|\[.*\])\s*```/m.freeze

    def self.apply(response)
      match = response.match(CODE_BLOCK_PATTERN)
      match ? match[1].strip : nil
    end
  end
end

# lib/skills_assessment/cleaning_strategies/markdown_removal_strategy.rb
module SkillsAssessment::CleaningStrategies
  class MarkdownRemovalStrategy
    PATTERNS = [
      /```json\s*/,           # Opening code block
      /```\s*$/,              # Closing code block
      /^#+\s+.*\n/,           # Headers
      /^\*\s+.*\n/,           # Bullet points
      /^-+\s+.*\n/,           # Dashes
      /^\d+\.\s+.*\n/,        # Numbered lists
      /\*\*.*?\*\*/,          # Bold
      /\*.*?\*/,              # Italic
      /^>.*\n/,               # Blockquotes
      /^.*\*\*Note:\*\*.*\n/, # Notes
      /^.*Note:.*\n/i         # Notes (case insensitive)
    ].freeze

    def self.apply(response)
      cleaned = PATTERNS.reduce(response) { |text, pattern| text.gsub(pattern, '') }
      cleaned.strip
    end
  end
end

# lib/skills_assessment/cleaning_strategies/json_extraction_strategy.rb
module SkillsAssessment::CleaningStrategies
  class JsonExtractionStrategy
    def self.apply(response)
      json_start = response.index('{') || response.index('[')
      json_end = response.rindex('}') || response.rindex(']')

      return nil unless json_start && json_end && json_start < json_end
      response[json_start..json_end]
    end
  end
end

# lib/skills_assessment/cleaning_strategies/json_repair_strategy.rb
module SkillsAssessment::CleaningStrategies
  class JsonRepairStrategy
    def self.apply(response)
      repair_incomplete_json(response)
    end

    private

    def self.repair_incomplete_json(json_str)
      open_braces = json_str.count('{') - json_str.count('}')
      open_brackets = json_str.count('[') - json_str.count(']')

      json_str += '}' * open_braces if open_braces > 0
      json_str += ']' * open_brackets if open_brackets > 0

      json_str
    end
  end
end
```

**Explanation**:
- Separates concerns using Strategy pattern
- Each strategy is focused and testable
- Easier to add new cleaning strategies
- More readable and maintainable

**Principles Applied**: Strategy Pattern, SRP, Composition, Testability

---

### Issue 4.2: Implicit error handling (silently returns nil)

**Problem**: JSON parsing errors are caught but not properly logged or reported.

**Before**:
```ruby
# In CLI
begin
  assessment = JSON.parse(cleaned)
rescue JSON::ParserError => e
  say '❌ Error: Failed to parse LLM response as JSON', :red
  say "Error: #{e.message}", :red
  exit 1
end
```

**After - Create Custom Exception Hierarchy**:
```ruby
# lib/skills_assessment/errors.rb
module SkillsAssessment
  class Error < StandardError; end
  
  class ResponseParseError < Error
    attr_reader :raw_response, :error_cause

    def initialize(raw_response, error_cause = nil)
      @raw_response = raw_response
      @error_cause = error_cause
      super("Failed to parse response as JSON: #{error_cause}")
    end
  end

  class ConfigError < Error; end
  class ValidationError < Error; end
end

# In ResponseCleaner
module SkillsAssessment
  class ResponseCleaner
    def clean(response)
      # ... cleaning logic
      validate_json_structure(cleaned)
    end

    private

    def validate_json_structure(json_str)
      JSON.parse(json_str)
      json_str
    rescue JSON::ParserError => e
      raise ResponseParseError.new(json_str, e)
    end
  end
end

# In CLI
def analyze(role, cv_file)
  # ...
rescue SkillsAssessment::ResponseParseError => e
  handle_parse_error(e)
rescue StandardError => e
  handle_unexpected_error(e)
end

private

def handle_parse_error(error)
  say '❌ Error: Failed to parse LLM response as JSON', :red
  say "Error: #{error.message}", :red
  say "Raw response: #{error.raw_response[0..200]}", :yellow if error.raw_response
  exit 1
end
```

**Explanation**:
- Creates explicit error types
- Better error reporting
- Preserves context for debugging
- Easier error handling

**Principles Applied**: Error handling, Exception hierarchy, Debugging

---

## 5. PromptLoader - Method Proliferation & Code Duplication

### Issue 5.1: Multiple nearly-identical load methods

**Problem**: 4 separate `load_*` methods with duplicated logic.

**Before**:
```ruby
def self.load(skill_type)
  file_name = skill_type.gsub('_', '-') + '-assessment.md'
  file_path = prompts_dir.join(file_name)
  return nil unless file_path.exist?
  extract_template(file_path.read)
end

def self.load_search_query_template
  file_path = prompts_dir.join('search-query-generation.md')
  return nil unless file_path.exist?
  extract_template(file_path.read)
end

def self.load_web_analysis_template
  file_path = prompts_dir.join('web-search-analysis.md')
  return nil unless file_path.exist?
  extract_template(file_path.read)
end

def self.load_web_research_template
  file_path = prompts_dir.join('web-research-assessment.md')
  return nil unless file_path.exist?
  extract_template(file_path.read)
end
```

**After - Use Template Method Pattern**:
```ruby
module SkillsAssessment
  class PromptLoader
    PROMPT_FILES = {
      skills: ->(type) { "#{type.gsub('_', '-')}-assessment.md" },
      search_query: 'search-query-generation.md',
      web_analysis: 'web-search-analysis.md',
      web_research: 'web-research-assessment.md'
    }.freeze

    def self.load(key, subkey = nil)
      new.load_prompt(key, subkey)
    end

    private

    def load_prompt(key, subkey)
      case key
      when :skills
        load_from_file(PROMPT_FILES[:skills].call(subkey))
      when :search_query, :web_analysis, :web_research
        load_from_file(PROMPT_FILES[key])
      else
        nil
      end
    end

    def load_from_file(filename)
      file_path = prompts_dir.join(filename)
      return nil unless file_path.exist?
      extract_template(file_path.read)
    end

    def prompts_dir
      Pathname.new(__dir__).join('prompts')
    end

    def extract_template(content)
      # ... existing extraction logic
    end
  end
end

# Usage:
PromptLoader.load(:skills, 'data_scientist')
PromptLoader.load(:web_analysis)
```

**Explanation**:
- Eliminates method duplication
- Uses declarative configuration
- Single entry point
- Easier to extend

**Principles Applied**: DRY, Template Method, KISS

---

## Summary of Refactoring Benefits

| Issue | Benefit |
|-------|---------|
| **CLI bloat** | Methods now < 10 lines, testable, easier to understand |
| **HtmlReportGenerator god object** | Separated into Presenters, reduced from 100+ to ~30 lines |
| **Repetitive code** | DRY principle applied throughout |
| **Magic strings** | Centralized in Constants module |
| **HTML string building** | More efficient, secure (XSS prevention) |
| **Duplication in LLMClient** | Extracted logging to separate class |
| **Complex ResponseCleaner** | Strategy pattern makes it extensible and testable |
| **PromptLoader repetition** | Single unified interface |

---

## Files to Create/Modify

1. **Create**: `lib/skills_assessment/role_config.rb`
2. **Create**: `lib/skills_assessment/esco_skills_loader.rb`
3. **Create**: `lib/skills_assessment/llm_response_logger.rb`
4. **Create**: `lib/skills_assessment/errors.rb`
5. **Create**: `lib/skills_assessment/presenters/report_presenter.rb`
6. **Create**: `lib/skills_assessment/presenters/skills_presenter.rb`
7. **Create**: `lib/skills_assessment/cleaning_strategies/` directory with strategy classes
8. **Modify**: `lib/cli.rb` (extract methods, use new classes)
9. **Modify**: `lib/html_report_generator.rb` (use presenters)
10. **Modify**: `lib/llm_client.rb` (remove duplication, use logger)
11. **Modify**: `lib/response_cleaner.rb` (use strategies)
12. **Modify**: `lib/prompt_loader.rb` (unify interface)

---

## Implementation Priority

**Phase 1 (High Priority - Critical Refactorings)**:
1. Extract `RoleConfig` class - fixes configuration hardcoding
2. Split `HtmlReportGenerator` into Presenters - reduces god object
3. Extract logging from `LLMClient` - eliminates duplication

**Phase 2 (Medium Priority - Code Quality)**:
4. Refactor `PromptLoader` - unifies interface
5. Implement error hierarchy - better error handling
6. Extract CLI methods - improves readability

**Phase 3 (Nice-to-Have - Polish)**:
7. Implement ResponseCleaner strategies - makes it extensible
8. ESCOSkillsLoader - optional refactoring
