# lib/constants.rb
module SkillsAssessment
  module Constants
    # API Configuration
    API_TIMEOUT = 30
    MAX_RETRIES = 3

    # Text Processing
    MAX_CV_TEXT_LENGTH = 8000

    # LLM Configuration
    DEFAULT_MAX_TOKENS = 2000
    LLM_TEMPERATURE = 0.1

    # Web Search
    MAX_SEARCH_RESULTS = 5
    SEARCH_TIMEOUT = 10

    # Assessment
    ASSESSMENT_DATE = "2025-10-17"
  end
end