# lib/skills_assessment/presenters/report_presenter.rb
# Coordinates all presenters for HTML report generation

module SkillsAssessment
  module Presenters
    class ReportPresenter
      def initialize(assessment, config, cv_filename)
        @assessment = assessment
        @config = config
        @cv_filename = cv_filename
      end

      # Accessor for template binding
      def get_binding
        binding
      end

      # Presenters
      def readiness
        @readiness_presenter ||= ReadinessPresenter.new(@assessment)
      end

      def skills
        @skills_presenter ||= SkillsPresenter.new(@assessment)
      end

      def essential_skills
        @essential_skills_presenter ||= EssentialSkillsPresenter.new(@assessment)
      end

      def config
        @config_presenter ||= ConfigPresenter.new(@config, @cv_filename)
      end

      # Delegate methods for convenience in templates
      def score
        readiness.score
      end

      def summary
        readiness.summary
      end

      def title
        config.title
      end

      # Convenience methods for essential skills arrays
      def essential_items
        essential_skills.essential
      end

      def missing_items
        essential_skills.missing
      end

      def optional_items
        essential_skills.optional
      end

      # Convenience predicates
      def has_strengths?
        readiness.has_strengths?
      end

      def has_development_areas?
        readiness.has_development_areas?
      end

      def has_identified_skills?
        skills.any?
      end

      def has_essential_skills?
        essential_skills.has_essential?
      end

      def has_missing_skills?
        essential_skills.has_missing?
      end

      def has_optional_skills?
        essential_skills.has_optional?
      end

      # Strength and development area lists
      def strengths
        readiness.strengths
      end

      def development_areas
        readiness.development_areas
      end
    end
  end
end
