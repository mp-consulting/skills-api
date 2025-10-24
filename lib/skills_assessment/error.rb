# lib/skills_assessment/errors.rb
# Custom exception classes for Skills Assessment

module SkillsAssessment
  # Base exception for all SkillsAssessment errors
  class Error < StandardError; end

  # Raised when LLM response cannot be parsed as JSON
  class ResponseParseError < Error
    attr_reader :raw_response, :error_cause

    def initialize(raw_response, error_cause = nil)
      @raw_response = raw_response
      @error_cause = error_cause
      message = 'Failed to parse response as JSON'
      message += ": #{error_cause.message}" if error_cause
      super(message)
    end
  end

  # Raised when role configuration is not found or invalid
  class ConfigError < Error
    def initialize(config_key)
      super("Configuration not found for: #{config_key}")
    end
  end

  # Raised when input validation fails
  class ValidationError < Error
    attr_reader :field, :value

    def initialize(field, value = nil, message = nil)
      @field = field
      @value = value
      msg = message || "Invalid #{field}"
      msg += ": #{value}" if value
      super(msg)
    end
  end

  # Raised when file operations fail
  class FileError < Error; end

  # Raised when LLM API call fails
  class LLMError < Error
    attr_reader :http_code, :response_body

    def initialize(http_code, response_body = nil)
      @http_code = http_code
      @response_body = response_body
      super("LLM API error - HTTP #{http_code}")
    end
  end
end
