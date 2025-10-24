# lib/html_report_generator.rb
# Generate HTML reports from CV assessment data

module SkillsAssessment
  class HtmlReportGenerator
    def initialize(assessment, config, cv_filename)
      @assessment = assessment
      @config = config
      @cv_filename = cv_filename
      @readiness = assessment['overall_readiness'] || {}
    end

    def generate
      ERB.new(load_template).result(binding)
    end

    private

    def score
      @readiness['score'].to_i
    end

    def score_color
      case score
      when 8..10
        '#4CAF50'
      when 6..7
        '#FFC107'
      else
        '#FF5722'
      end
    end

    def skills_by_category
      @assessment['identified_skills']&.group_by { |s| s['skill_category'] } || {}
    end

    def render_skills_html
      html = ''
      skills_by_category.each do |category, skills|
        html += "    <h3 class=\"category-title\">#{category}</h3>\n"
        html += "    <table class=\"skills-table\">\n"
        html += "      <thead>\n"
        html += "        <tr>\n"
        html += "          <th>Skill Name</th>\n"
        html += "          <th>Level</th>\n"
        html += "          <th>Confidence</th>\n"
        html += "          <th>Proficiency</th>\n"
        html += "          <th>Evidence</th>\n"
        html += "        </tr>\n"
        html += "      </thead>\n"
        html += "      <tbody>\n"
        skills.each_with_index do |skill, idx|
          level = skill['proficiency_level'].to_i
          confidence = (skill['confidence_score'].to_f * 100).round
          evidence = skill['evidence'] || 'No evidence provided'
          row_class = idx.even? ? 'even' : 'odd'

          html += "        <tr class=\"#{row_class}\">\n"
          html += "          <td class=\"skill-name-cell\"><strong>#{skill['skill_name']}</strong></td>\n"
          html += "          <td class=\"skill-level-cell\">#{level}/10</td>\n"
          html += "          <td class=\"skill-confidence-cell\">#{confidence}%</td>\n"
          html += "          <td class=\"skill-bar-cell\">\n"
          html += "            <div class=\"skill-bar-inline\">\n"
          html += "              <div class=\"skill-fill-inline\" style=\"width: #{level * 10}%\"></div>\n"
          html += "            </div>\n"
          html += "          </td>\n"
          html += "          <td class=\"skill-evidence-cell\"><em>#{evidence}</em></td>\n"
          html += "        </tr>\n"
        end
        html += "      </tbody>\n"
        html += "    </table>\n\n"
      end
      html
    end

    def render_essential_skills_html
      skills = @assessment['essential_skills_found'] || []
      return '' unless skills.any?

      html = "    <div class=\"skills-list found-skills\">\n"
      skills.each do |skill|
        html += "      <div class=\"skill-item found\"><span class=\"skill-icon\">✓</span> #{skill}</div>\n"
      end
      html += "    </div>\n"
      html
    end

    def render_missing_skills_html
      skills = @assessment['missing_essential_skills'] || []
      return '' unless skills.any?

      html = "    <div class=\"skills-list missing-skills\">\n"
      skills.each do |skill|
        html += "      <div class=\"skill-item missing\"><span class=\"skill-icon\">○</span> #{skill}</div>\n"
      end
      html += "    </div>\n"
      html
    end

    def render_optional_skills_html
      skills = @assessment['optional_skills_found'] || []
      return '' unless skills.any?

      html = "    <div class=\"skills-list optional-skills\">\n"
      skills.each do |skill|
        html += "      <div class=\"skill-item optional\"><span class=\"skill-icon\">●</span> #{skill}</div>\n"
      end
      html += "    </div>\n"
      html
    end

    def render_strengths_html
      strengths = @readiness['strengths'] || []
      return '' unless strengths.any?

      html = "    <ul class=\"strengths-list\">\n"
      strengths.each do |strength|
        html += "      <li>#{strength}</li>\n"
      end
      html += "    </ul>\n"
      html
    end

    def render_development_html
      areas = @readiness['development_areas'] || []
      return '' unless areas.any?

      html = "    <ul class=\"development-list\">\n"
      areas.each do |area|
        html += "      <li>#{area}</li>\n"
      end
      html += "    </ul>\n"
      html
    end

    def timestamp
      Time.now.strftime('%Y-%m-%d %H:%M:%S')
    end

    def summary
      @readiness['summary'] || 'No summary available'
    end

    def title
      @config[:title]
    end

    def essential_skills_count
      (@assessment['essential_skills_found'] || []).length
    end

    def missing_skills_count
      (@assessment['missing_essential_skills'] || []).length
    end

    def optional_skills_count
      (@assessment['optional_skills_found'] || []).length
    end

    def has_strengths?
      @readiness['strengths']&.any? || false
    end

    def has_development_areas?
      @readiness['development_areas']&.any? || false
    end

    def has_identified_skills?
      @assessment['identified_skills']&.any? || false
    end

    def has_essential_skills?
      @assessment['essential_skills_found']&.any? || false
    end

    def has_optional_skills?
      @assessment['optional_skills_found']&.any? || false
    end

    def has_missing_skills?
      @assessment['missing_essential_skills']&.any? || false
    end

    def load_template
      template_path = Pathname.new(__dir__).join('templates', 'report.html.erb')
      File.read(template_path)
    end
  end
end
