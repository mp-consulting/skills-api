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
          { 'type' => 'text', 'text' => prompt },
          {
            'type' => 'document',
            'source' => {
              'type' => 'base64',
              'media_type' => 'application/pdf',
              'data' => base64_pdf
            }
          }
        ]

        payload = {
          model: Constants::LLM_MODEL,
          max_tokens: max_tokens,
          temperature: Constants::LLM_TEMPERATURE,
          messages: [
            { role: 'user', content: content }
          ]
        }

        # Make HTTP request directly to Anthropic API
        uri = URI("#{Constants::ANTHROPIC_BASE_URL}/v1/messages")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.path)
        request['anthropic-version'] = Constants::ANTHROPIC_API_VERSION
        request['content-type'] = 'application/json'
        request['x-api-key'] = @api_key
        request.body = payload.to_json

        response = http.request(request)

        if response.code.to_i == 200
          result = JSON.parse(response.body)
          # Log the response
          response_text = result['content']&.first&.dig('text')
          LLMResponseLogger.log(result, prompt, max_tokens, pdf_path)

          # Extract text from response
          response_text
        else
          warn "❌ Error: Anthropic API error - HTTP #{response.code}: #{response.body}"
          nil
        end
      rescue StandardError => e
        warn "❌ Error: LLM API call with PDF failed: #{e.message}"
        nil
      end
    end

    private

    # Private methods can be added here as needed
  end
end
