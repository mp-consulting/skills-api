# lib/skills_assessment/presenters/config_presenter.rb
# Presents configuration data for templates

module SkillsAssessment
  module Presenters
    class ConfigPresenter
      def initialize(config, cv_filename = nil)
        @config = config
        @cv_filename = cv_filename
      end

      def title
        @config[:title]
      end

      attr_reader :cv_filename

      def timestamp
        Time.now.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end
end
