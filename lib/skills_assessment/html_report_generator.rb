# lib/html_report_generator.rb
# Generate HTML reports from CV assessment data

require 'erb'
require 'pathname'

module SkillsAssessment
  class HtmlReportGenerator
    def initialize(assessment, config, cv_filename)
      @assessment = assessment
      @config = config
      @cv_filename = cv_filename
    end

    def generate
      presenter = Presenters::ReportPresenter.new(@assessment, @config, @cv_filename)
      ERB.new(load_template).result(presenter.get_binding)
    end

    private

    def load_template
      template_path = Pathname.new(__dir__).join('templates', 'report.html.erb')
      File.read(template_path)
    end
  end
end
