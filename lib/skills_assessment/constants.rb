# lib/constants.rb
module SkillsAssessment
  module Constants
    # Anthropic API Configuration
    ANTHROPIC_BASE_URL = 'https://api.anthropic.com'
    ANTHROPIC_API_VERSION = '2023-06-01'
    LLM_MODEL = 'claude-sonnet-4-5-20250929'

    # LLM Configuration
    LLM_TEMPERATURE = 0.1
    DEFAULT_MAX_TOKENS = 2000
    API_TIMEOUT = 30

    # Role Configuration
    VALID_ROLES = %w[data-scientist it-manager software-architect].freeze

    # Text Processing
    MAX_CV_TEXT_LENGTH = 8000

    # Retry Configuration
    MAX_RETRIES = 3

    # Web Search
    MAX_SEARCH_RESULTS = 5
    SEARCH_TIMEOUT = 10

    # Assessment
    ASSESSMENT_DATE = '2025-10-17'
  end
end
