# lib/skills_assessment/presenters/readiness_presenter.rb
# Presents overall readiness and assessment data

module SkillsAssessment
  module Presenters
    class ReadinessPresenter
      def initialize(assessment)
        @assessment = assessment
        @readiness = assessment['overall_readiness'] || {}
      end

      def score
        (@readiness['score'] || 0).to_i
      end

      def summary
        @readiness['summary'] || 'No summary available'
      end

      def strengths
        @readiness['strengths'] || []
      end

      def development_areas
        @readiness['development_areas'] || []
      end

      def has_strengths?
        strengths.any?
      end

      def has_development_areas?
        development_areas.any?
      end
    end
  end
end
