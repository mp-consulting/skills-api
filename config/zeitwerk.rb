# config/zeitwerk.rb
# Zeitwerk loader configuration for automatic class loading

require 'zeitwerk'

# Create a custom loader for lib directory
loader = Zeitwerk::Loader.new

# Add lib directory to the loader
loader.push_dir(File.expand_path('../lib', __dir__))

# Add inflector rules for custom naming
loader.inflector.inflect(
  'llm_client' => 'LLMClient',
  'llm_response_logger' => 'LLMResponseLogger',
  'response_cleaner' => 'ResponseCleaner',
  'prompt_loader' => 'PromptLoader',
  'html_report_generator' => 'HtmlReportGenerator',
  'role_config' => 'RoleConfig',
  'error' => 'Error'
)

# Setup the loader first
loader.setup

# Then eager load all classes
loader.eager_load

# Return loader
loader
