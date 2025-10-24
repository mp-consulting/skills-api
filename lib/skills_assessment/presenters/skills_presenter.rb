# lib/skills_assessment/presenters/skills_presenter.rb
# Presents identified skills data

module SkillsAssessment
  module Presenters
    class SkillsPresenter
      def initialize(assessment)
        @assessment = assessment
        @skills = assessment['identified_skills'] || []
      end

      def by_category
        @skills.group_by { |s| s['skill_category'] }
      end

      def any?
        @skills.any?
      end

      def categories
        by_category.keys
      end

      def skills_for(category)
        by_category[category] || []
      end

      def count
        @skills.length
      end
    end
  end
end
