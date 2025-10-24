# lib/skills_assessment/presenters/essential_skills_presenter.rb
# Presents essential, missing, and optional skills

module SkillsAssessment
  module Presenters
    class EssentialSkillsPresenter
      def initialize(assessment)
        @assessment = assessment
      end

      # Accessors for template convenience (template uses these names)
      def essential
        @assessment['essential_skills_found'] || []
      end

      def missing
        @assessment['missing_essential_skills'] || []
      end

      def optional
        @assessment['optional_skills_found'] || []
      end

      # Aliases for backward compatibility
      def essential_skills
        essential
      end

      def missing_skills
        missing
      end

      def optional_skills
        optional
      end

      def has_essential?
        essential.any?
      end

      def has_missing?
        missing.any?
      end

      def has_optional?
        optional.any?
      end

      def count
        essential.length
      end

      def essential_count
        essential.length
      end

      def missing_count
        missing.length
      end

      def optional_count
        optional.length
      end
    end
  end
end
