# lib/skills_assessment/role_identifier.rb
# Identifies relevant roles from CV analysis

module SkillsAssessment
  class RoleIdentifier
    def initialize(cv_path, api_key:)
      @cv_path = cv_path
      @api_key = api_key
    end

    # Identify relevant roles from CV
    def identify_roles
      prompt = build_identification_prompt
      llm_client = LLMClient.new(@api_key)

      response = llm_client.call_with_pdf(prompt, @cv_path, 2000)
      parse_roles(response)
    end

    private

    def build_identification_prompt
      template = load_prompt_template
      roles_list = RoleConfig.valid_roles.map { |r| "- #{r}" }.join("\n")

      # Format prompt with roles (CV content will be provided by LLMClient as PDF attachment)
      format(template, roles_list: roles_list, cv_text: '[CV content provided as PDF attachment]')
    end

    def load_prompt_template
      prompt_file = File.join(
        File.dirname(__FILE__),
        'prompts',
        'role-identification.md'
      )

      raise FileError, "Prompt file not found: #{prompt_file}" unless File.exist?(prompt_file)

      File.read(prompt_file)
    end

    def parse_roles(response)
      cleaner = ResponseCleaner.new
      cleaned = cleaner.clean(response)

      JSON.parse(cleaned)
    rescue JSON::ParserError => e
      raise ResponseParseError.new(response, e)
    end
  end
end
