# lib/llm_client.rb
require 'net/http'
require 'uri'
require 'json'
require 'fileutils'

module SkillsAssessment
  class LLMClient
    def initialize(api_key = nil)
      @api_key = api_key || ENV['ANTHROPIC_API_KEY']
    end

    def call_with_pdf(prompt, pdf_path, max_tokens = Constants::DEFAULT_MAX_TOKENS)
      return nil unless @api_key
      return nil unless File.exist?(pdf_path)

      begin
        # Read PDF file and encode as base64
        pdf_data = File.read(pdf_path)
        base64_pdf = Base64.strict_encode64(pdf_data)

        # Build request payload with document
        content = [
          { "type" => "text", "text" => prompt },
          {
            "type" => "document",
            "source" => {
              "type" => "base64",
              "media_type" => "application/pdf",
              "data" => base64_pdf
            }
          }
        ]

        payload = {
          model: "claude-sonnet-4-5-20250929",
          max_tokens: max_tokens,
          temperature: Constants::LLM_TEMPERATURE,
          messages: [
            { role: "user", content: content }
          ]
        }

        # Make HTTP request directly to Anthropic API
        uri = URI('https://api.anthropic.com/v1/messages')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.path)
        request['anthropic-version'] = '2023-06-01'
        request['content-type'] = 'application/json'
        request['x-api-key'] = @api_key
        request.body = payload.to_json

        response = http.request(request)
        
        if response.code.to_i == 200
          result = JSON.parse(response.body)
          # Log the raw response
          log_raw_response_from_hash(result, prompt, max_tokens, pdf_path)
          
          # Extract text from response
          if result['content'] && result['content'].first && result['content'].first['text']
            result['content'].first['text']
          else
            nil
          end
        else
          warn "❌ Error: Anthropic API error - HTTP #{response.code}: #{response.body}"
          nil
        end
      rescue => e
        warn "❌ Error: LLM API call with PDF failed: #{e.message}"
        nil
      end
    end

    private

    def log_raw_response(response, prompt, max_tokens, pdf_path = nil)
      # Check if logging is enabled via ENV
      return unless ENV['LLM_LOGGING'] == 'true'
      
      timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
      filename = "llm_response_#{timestamp}.json"

      # Create logs/llm directory if it doesn't exist
      logs_dir = File.join(Dir.pwd, "logs", "llm")
      FileUtils.mkdir_p(logs_dir)

      filepath = File.join(logs_dir, filename)

      log_data = {
        timestamp: Time.now.iso8601,
        model: "claude-sonnet-4-5-20250929",
        max_tokens: max_tokens,
        temperature: Constants::LLM_TEMPERATURE,
        prompt_preview: prompt[0..200] + (prompt.length > 200 ? "..." : ""),
        pdf_file: pdf_path ? File.basename(pdf_path) : nil,
        raw_response: response&.to_h,
        success: !response.nil?
      }

      File.write(filepath, JSON.pretty_generate(log_data))
      puts "🔍 LLM response logged to: #{filepath}"
    rescue => e
      # Silently fail if logging directory creation fails
      warn "⚠️ Failed to log LLM response: #{e.message}"
    end

    def log_raw_response_from_hash(response_hash, prompt, max_tokens, pdf_path = nil)
      # Check if logging is enabled via ENV
      return unless ENV['LLM_LOGGING'] == 'true'
      
      timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
      filename = "llm_response_#{timestamp}.json"

      # Create logs/llm directory if it doesn't exist
      logs_dir = File.join(Dir.pwd, "logs", "llm")
      FileUtils.mkdir_p(logs_dir)

      filepath = File.join(logs_dir, filename)

      response_text = response_hash['content']&.first&.dig('text')

      log_data = {
        timestamp: Time.now.iso8601,
        model: "claude-sonnet-4-5-20250929",
        max_tokens: max_tokens,
        temperature: Constants::LLM_TEMPERATURE,
        prompt_preview: prompt[0..200] + (prompt.length > 200 ? "..." : ""),
        pdf_file: pdf_path ? File.basename(pdf_path) : nil,
        raw_response: response_hash,
        response_text: response_text,
        success: !response_hash.nil?
      }

      File.write(filepath, JSON.pretty_generate(log_data))
      puts "🔍 LLM response logged to: #{filepath}"
    rescue => e
      # Silently fail if logging directory creation fails
      warn "⚠️ Failed to log LLM response: #{e.message}"
    end
  end
end
