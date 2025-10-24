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
      ERB.new(template).result(binding)
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
      html = ""
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
      return "" unless skills.any?
      html = "    <div class=\"skills-list found-skills\">\n"
      skills.each do |skill|
        html += "      <div class=\"skill-item found\"><span class=\"skill-icon\">✓</span> #{skill}</div>\n"
      end
      html += "    </div>\n"
      html
    end

    def render_missing_skills_html
      skills = @assessment['missing_essential_skills'] || []
      return "" unless skills.any?
      html = "    <div class=\"skills-list missing-skills\">\n"
      skills.each do |skill|
        html += "      <div class=\"skill-item missing\"><span class=\"skill-icon\">○</span> #{skill}</div>\n"
      end
      html += "    </div>\n"
      html
    end

    def render_optional_skills_html
      skills = @assessment['optional_skills_found'] || []
      return "" unless skills.any?
      html = "    <div class=\"skills-list optional-skills\">\n"
      skills.each do |skill|
        html += "      <div class=\"skill-item optional\"><span class=\"skill-icon\">●</span> #{skill}</div>\n"
      end
      html += "    </div>\n"
      html
    end

    def render_strengths_html
      strengths = @readiness['strengths'] || []
      return "" unless strengths.any?
      html = "    <ul class=\"strengths-list\">\n"
      strengths.each do |strength|
        html += "      <li>#{strength}</li>\n"
      end
      html += "    </ul>\n"
      html
    end

    def render_development_html
      areas = @readiness['development_areas'] || []
      return "" unless areas.any?
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

    def has_missing_skills?
      @assessment['missing_essential_skills']&.any? || false
    end

    def has_optional_skills?
      @assessment['optional_skills_found']&.any? || false
    end

    def template
      <<~'HTML'
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title><%= title %> - Assessment Report</title>
          <style>
            * {
              margin: 0;
              padding: 0;
              box-sizing: border-box;
            }

            body {
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
              background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
              min-height: 100vh;
              padding: 20px;
              color: #333;
            }

            .container {
              max-width: 1200px;
              margin: 0 auto;
              background: white;
              border-radius: 10px;
              box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
              overflow: hidden;
            }

            .header {
              background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
              color: white;
              padding: 40px 30px;
              text-align: center;
            }

            .header h1 {
              font-size: 28px;
              margin-bottom: 10px;
              font-weight: 600;
            }

            .header p {
              opacity: 0.9;
              font-size: 14px;
            }

            .score-section {
              display: flex;
              justify-content: center;
              gap: 30px;
              margin-top: 30px;
            }

            .score-card {
              background: white;
              padding: 20px 30px;
              border-radius: 8px;
              text-align: center;
              box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .score-number {
              font-size: 48px;
              font-weight: bold;
              color: <%= score_color %>;
              margin-bottom: 5px;
            }

            .score-label {
              font-size: 12px;
              color: #666;
              text-transform: uppercase;
              letter-spacing: 1px;
            }

            .content {
              padding: 40px 30px;
            }

            .section {
              margin-bottom: 40px;
            }

            .section h2 {
              font-size: 22px;
              margin-bottom: 20px;
              color: #333;
              border-bottom: 3px solid #667eea;
              padding-bottom: 10px;
              display: inline-block;
            }

            .summary {
              background: #f5f7fa;
              padding: 20px;
              border-radius: 8px;
              margin-bottom: 20px;
              line-height: 1.6;
            }

            .strengths-list, .development-list {
              list-style: none;
            }

            .strengths-list li {
              padding: 10px 0;
              padding-left: 25px;
              position: relative;
              color: #333;
              line-height: 1.5;
            }

            .strengths-list li:before {
              content: "✓";
              position: absolute;
              left: 0;
              color: #4CAF50;
              font-weight: bold;
              font-size: 16px;
            }

            .development-list li {
              padding: 10px 0;
              padding-left: 25px;
              position: relative;
              color: #333;
              line-height: 1.5;
            }

            .development-list li:before {
              content: "○";
              position: absolute;
              left: 0;
              color: #FFC107;
              font-weight: bold;
              font-size: 16px;
            }

            .category-title {
              font-size: 16px;
              font-weight: 600;
              color: #667eea;
              margin-top: 25px;
              margin-bottom: 15px;
            }

            .skills-grid {
              display: grid;
              grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
              gap: 15px;
              margin-bottom: 20px;
            }

            .skill-card {
              background: #f5f7fa;
              padding: 15px;
              border-radius: 8px;
              border-left: 4px solid #667eea;
              transition: transform 0.2s, box-shadow 0.2s;
            }

            .skill-card:hover {
              transform: translateY(-2px);
              box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
            }

            .skills-list-detailed {
              display: flex;
              flex-direction: column;
              gap: 15px;
              margin-bottom: 20px;
            }

            .skill-detail-card {
              background: #f5f7fa;
              padding: 20px;
              border-radius: 8px;
              border-left: 4px solid #667eea;
              transition: transform 0.2s, box-shadow 0.2s;
            }

            .skill-detail-card:hover {
              transform: translateX(4px);
              box-shadow: 0 4px 16px rgba(102, 126, 234, 0.2);
            }

            .skill-header {
              display: flex;
              justify-content: space-between;
              align-items: flex-start;
              margin-bottom: 12px;
            }

            .skill-name {
              font-weight: 600;
              color: #333;
              margin-bottom: 5px;
              font-size: 16px;
              flex: 1;
            }

            .skill-meta {
              font-size: 12px;
              color: #666;
              margin-bottom: 10px;
              text-align: right;
              white-space: nowrap;
            }

            .skill-bar {
              background: #e0e0e0;
              height: 6px;
              border-radius: 3px;
              overflow: hidden;
            }

            .skill-fill {
              background: linear-gradient(90deg, #667eea, #764ba2);
              height: 100%;
              border-radius: 3px;
              transition: width 0.3s ease;
            }

            .skill-evidence {
              margin-top: 15px;
              padding-top: 15px;
              border-top: 1px solid #e0e0e0;
            }

            .evidence-label {
              display: inline-block;
              font-weight: 600;
              color: #667eea;
              font-size: 12px;
              text-transform: uppercase;
              letter-spacing: 0.5px;
              margin-bottom: 8px;
            }

            .evidence-text {
              font-size: 14px;
              color: #555;
              line-height: 1.6;
              font-style: italic;
              margin: 0;
              padding: 10px;
              background: white;
              border-radius: 4px;
              border-left: 3px solid #764ba2;
            }

            /* Skills Table Styles */
            .skills-table {
              width: 100%;
              border-collapse: collapse;
              margin-bottom: 30px;
              box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
              border-radius: 8px;
              overflow: hidden;
              table-layout: auto;
            }

            .skills-table thead {
              background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
              color: white;
            }

            .skills-table th {
              padding: 15px;
              text-align: left;
              font-weight: 600;
              font-size: 13px;
              text-transform: uppercase;
              letter-spacing: 0.5px;
              vertical-align: middle;
            }

            .skills-table th:nth-child(2),
            .skills-table th:nth-child(3),
            .skills-table th:nth-child(4) {
              text-align: center;
            }

            .skills-table tbody tr.even {
              background-color: #f9fafb;
            }

            .skills-table tbody tr.odd {
              background-color: white;
            }

            .skills-table tbody tr:hover {
              background-color: #f0f2f8;
              transition: background-color 0.2s ease;
            }

            .skills-table td {
              padding: 14px 15px;
              border-bottom: 1px solid #e5e7eb;
              font-size: 14px;
              color: #374151;
            }

            .skills-table tbody tr:last-child td {
              border-bottom: none;
            }

            .skill-name-cell {
              font-weight: 600;
              color: #1f2937;
              min-width: 180px;
              width: 20%;
              text-align: left;
              vertical-align: middle;
              white-space: normal;
            }

            .skill-level-cell {
              text-align: center;
              font-weight: 600;
              color: #667eea;
              min-width: 70px;
              width: 12%;
              vertical-align: middle;
              white-space: nowrap;
            }

            .skill-confidence-cell {
              text-align: center;
              min-width: 90px;
              width: 12%;
              vertical-align: middle;
              white-space: nowrap;
            }

            .skill-bar-cell {
              min-width: 120px;
              width: 15%;
              text-align: center;
              vertical-align: middle;
            }

            .skill-evidence-cell {
              color: #666;
              font-style: italic;
              min-width: 250px;
              width: auto;
              flex-grow: 1;
              text-align: left;
              vertical-align: middle;
              word-wrap: break-word;
              overflow-wrap: break-word;
            }

            .skill-bar-inline {
              background: #e5e7eb;
              height: 8px;
              border-radius: 4px;
              overflow: hidden;
              position: relative;
            }

            .skill-fill-inline {
              background: linear-gradient(90deg, #667eea, #764ba2);
              height: 100%;
              border-radius: 4px;
              transition: width 0.3s ease;
            }

            .skill-evidence-cell {
              color: #666;
              font-style: italic;
              max-width: 400px;
              word-wrap: break-word;
            }

            /* Responsive table */
            @media (max-width: 1024px) {
              .skills-table {
                font-size: 12px;
              }

              .skills-table th,
              .skills-table td {
                padding: 10px;
              }
            }

            @media (max-width: 768px) {
              .skills-table {
                font-size: 11px;
              }

              .skills-table th,
              .skills-table td {
                padding: 8px;
              }

              .skill-name-cell {
                min-width: 120px;
              }

              .skill-evidence-cell {
                max-width: 200px;
              }
            }

            .skills-list {
              display: grid;
              grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
              gap: 10px;
            }

            .skill-item {
              padding: 12px 15px;
              border-radius: 6px;
              font-size: 14px;
              display: flex;
              align-items: center;
              gap: 10px;
            }

            .skill-icon {
              font-weight: bold;
              font-size: 16px;
            }

            .skill-item.found {
              background: #E8F5E9;
              color: #2E7D32;
            }

            .skill-item.missing {
              background: #FFF3E0;
              color: #E65100;
            }

            .skill-item.optional {
              background: #E3F2FD;
              color: #1565C0;
            }

            .two-column {
              display: grid;
              grid-template-columns: 1fr 1fr;
              gap: 30px;
            }

            @media (max-width: 768px) {
              .two-column {
                grid-template-columns: 1fr;
              }

              .skills-grid {
                grid-template-columns: 1fr;
              }

              .score-section {
                flex-direction: column;
              }

              .header h1 {
                font-size: 20px;
              }

              .score-number {
                font-size: 36px;
              }
            }

            .footer {
              background: #f5f7fa;
              padding: 20px 30px;
              text-align: center;
              font-size: 12px;
              color: #666;
              border-top: 1px solid #eee;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1><%= title %></h1>
              <p>Professional Skills Assessment Report</p>
              <div class="score-section">
                <div class="score-card">
                  <div class="score-number"><%= score %></div>
                  <div class="score-label">Overall Score</div>
                </div>
              </div>
            </div>

            <div class="content">
              <!-- Overall Readiness Section -->
              <div class="section">
                <h2>📊 Overall Assessment</h2>
                <div class="summary">
                  <%= summary %>
                </div>
              </div>

              <!-- Strengths and Development -->
              <% if has_strengths? || has_development_areas? %>
              <div class="two-column">
              <% end %>

              <% if has_strengths? %>
              <div class="section">
                <h2>✓ Strengths</h2>
                <%= render_strengths_html %>
              </div>
              <% end %>

              <% if has_development_areas? %>
              <div class="section">
                <h2>○ Development Areas</h2>
                <%= render_development_html %>
              </div>
              <% end %>

              <% if has_strengths? || has_development_areas? %>
              </div>
              <% end %>

              <!-- Identified Skills Section -->
              <% if has_identified_skills? %>
              <div class="section">
                <h2>🎯 Identified Skills</h2>
                <%= render_skills_html %>
              </div>
              <% end %>

              <!-- Essential Skills Found -->
              <% if has_essential_skills? %>
              <div class="section">
                <h2>✅ Essential ESCO Skills (<%= essential_skills_count %>)</h2>
                <%= render_essential_skills_html %>
              </div>
              <% end %>

              <!-- Missing Essential Skills -->
              <% if has_missing_skills? %>
              <div class="section">
                <h2>⚠️ Missing Essential Skills (<%= missing_skills_count %>)</h2>
                <%= render_missing_skills_html %>
              </div>
              <% end %>

              <!-- Optional Skills -->
              <% if has_optional_skills? %>
              <div class="section">
                <h2>ℹ️ Optional Skills (<%= optional_skills_count %>)</h2>
                <%= render_optional_skills_html %>
              </div>
              <% end %>
            </div>

            <div class="footer">
              <p>Generated on <%= timestamp %> | CV File: <%= @cv_filename %></p>
            </div>
          </div>
        </body>
        </html>
      HTML
    end
  end
end
