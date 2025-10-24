#!/usr/bin/env ruby
# Test script to verify presenter pattern works correctly

require 'json'
require 'dotenv'
Dotenv.load

require_relative 'config/zeitwerk'

# Load test assessment data
assessment_json = File.read('./reports/data-scientist_CV_Antoine_20251024_100131.json')
assessment = JSON.parse(assessment_json)

# Setup config
config = {
  title: 'Data Scientist Assessment',
  role: 'data-scientist'
}

cv_filename = 'CV_Antoine.pdf'

# Create presenter
presenter = SkillsAssessment::Presenters::ReportPresenter.new(assessment, config, cv_filename)

puts "Testing Presenter Pattern:"
puts "=" * 50

# Test readiness presenter
puts "\n✓ Readiness Presenter:"
puts "  Score: #{presenter.readiness.score}"
puts "  Summary: #{presenter.readiness.summary[0..100]}..."
puts "  Strengths count: #{presenter.readiness.strengths.length}"
puts "  Development areas count: #{presenter.readiness.development_areas.length}"

# Test skills presenter
puts "\n✓ Skills Presenter:"
puts "  Total skills: #{presenter.skills.count}"
puts "  Categories: #{presenter.skills.by_category.keys.join(', ')}"

# Test essential skills presenter
puts "\n✓ Essential Skills Presenter:"
puts "  Essential skills count: #{presenter.essential_items.length}"
puts "  Missing skills count: #{presenter.missing_items.length}"
puts "  Optional skills count: #{presenter.optional_items.length}"

# Test config presenter
puts "\n✓ Config Presenter:"
puts "  Title: #{presenter.config.title}"
puts "  CV Filename: #{presenter.config.cv_filename}"
puts "  Timestamp: #{presenter.config.timestamp}"

# Test convenience methods
puts "\n✓ Convenience Methods:"
puts "  score: #{presenter.score}"
puts "  title: #{presenter.title}"
puts "  has_strengths?: #{presenter.has_strengths?}"
puts "  has_development_areas?: #{presenter.has_development_areas?}"
puts "  has_identified_skills?: #{presenter.has_identified_skills?}"
puts "  has_essential_skills?: #{presenter.has_essential_skills?}"
puts "  has_missing_skills?: #{presenter.has_missing_skills?}"
puts "  has_optional_skills?: #{presenter.has_optional_skills?}"

# Test template rendering
puts "\n✓ Template Rendering:"
begin
  html = SkillsAssessment::HtmlReportGenerator.new(assessment, config, cv_filename).generate
  puts "  HTML generated successfully: #{html.length} bytes"
  puts "  Contains '<%= score %>' replacement? #{html.include?('<%= score %>')}"
  puts "  Contains score value? #{html.include?(presenter.score.to_s)}"
  puts "  Contains title? #{html.include?(config[:title])}"
  
  # Save HTML file for manual inspection
  output_file = 'test_report.html'
  File.write(output_file, html)
  puts "  Saved to: #{output_file}"
rescue => e
  puts "  ERROR: #{e.message}"
  puts e.backtrace.first(5)
end

puts "\n" + "=" * 50
puts "✅ All tests completed!"
