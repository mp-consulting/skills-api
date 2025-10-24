# lib/skills_assessment/llm_response_logger.rb
# Logging for LLM API responses

require 'fileutils'
require 'json'

module SkillsAssessment
  class LLMResponseLogger
    LOGS_DIR = 'logs/llm'

    # Log LLM response if logging is enabled
    # @param response_data [Hash, nil] the parsed response from API
    # @param prompt [String] the prompt sent
    # @param max_tokens [Integer] max tokens requested
    # @param pdf_path [String, nil] path to PDF file analyzed
    def self.log(response_data, prompt, max_tokens, pdf_path = nil)
      return unless logging_enabled?

      new(response_data, prompt, max_tokens, pdf_path).write_log
    rescue StandardError => e
      warn "⚠️  Failed to log LLM response: #{e.message}"
    end

    # Check if logging is enabled via ENV
    # @return [Boolean]
    def self.logging_enabled?
      ENV['LLM_LOGGING'] == 'true'
    end

    def initialize(response_data, prompt, max_tokens, pdf_path = nil)
      @response_data = response_data
      @prompt = prompt
      @max_tokens = max_tokens
      @pdf_path = pdf_path
    end

    # Write log file to logs/llm directory
    def write_log
      FileUtils.mkdir_p(LOGS_DIR)
      File.write(log_file_path, JSON.pretty_generate(log_data))
      puts "🔍 LLM response logged to: #{log_file_path}"
    end

    private

    def log_data
      {
        timestamp: Time.now.iso8601,
        model: Constants::LLM_MODEL,
        max_tokens: @max_tokens,
        temperature: Constants::LLM_TEMPERATURE,
        prompt_preview: truncate_prompt(@prompt),
        pdf_file: @pdf_path ? File.basename(@pdf_path) : nil,
        raw_response: @response_data,
        success: !@response_data.nil?
      }
    end

    def log_file_path
      timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
      File.join(LOGS_DIR, "llm_response_#{timestamp}.json")
    end

    def truncate_prompt(prompt, length = 200)
      prompt[0..length] + (prompt.length > length ? '...' : '')
    end
  end
end
