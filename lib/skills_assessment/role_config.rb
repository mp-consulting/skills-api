# lib/skills_assessment/role_config.rb
# Centralized role configuration management

module SkillsAssessment
  class RoleConfig
    # Configuration for each role
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

    # Get configuration for a specific role
    # @param role [String] the role name
    # @return [Hash] configuration hash with keys: prompt_key, max_tokens, title
    # @raise [ConfigError] if role is not found
    def self.for(role)
      CONFIGS[role] || raise(ConfigError.new(role))
    end

    # Get all valid role names
    # @return [Array<String>] list of valid role names
    def self.valid_roles
      CONFIGS.keys
    end

    # Check if role is valid
    # @param role [String] the role name
    # @return [Boolean] true if role exists
    def self.valid?(role)
      CONFIGS.key?(role)
    end

    # Get ESCO file path for a role
    # @param role [String] the role name
    # @return [String] path to ESCO CSV file
    def self.esco_file_path(role)
      "lib/skills_assessment/ESCO/#{role}-skills.csv"
    end
  end
end
