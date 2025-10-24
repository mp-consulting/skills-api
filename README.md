# Skills API - CV Skills Assessment Tool

A powerful CLI tool for analyzing CVs and identifying professional skills using AI. This project leverages Claude AI to perform comprehensive skills assessment across multiple roles and provides detailed reports in JSON and HTML formats.

## Features

- **Multi-Role Analysis**: Assess CVs for specialized roles including:
  - Data Scientist
  - IT Manager
  - Software Architect

- **Comprehensive Skill Assessment**: 
  - Hard skills (technical, programming, tools, frameworks)
  - Soft skills (communication, teamwork, leadership)
  - Leadership and management capabilities
  - ESCO skills framework alignment

- **Role Identification**: Automatically identify relevant roles from a CV based on experience and background

- **Flexible Output Formats**:
  - Interactive HTML reports with visual presentation
  - JSON data for programmatic access
  - Colored console output for quick feedback

- **AI-Powered Analysis**: Integrates with Anthropic Claude for intelligent CV parsing and skill extraction

- **Logging & Debugging**: Optional LLM response logging for debugging and analysis

## Project Structure

```
skills-api/
├── cli.rb                          # Main CLI entry point (Thor-based)
├── Gemfile                         # Ruby dependencies
├── config/
│   └── zeitwerk.rb                 # Code auto-loading configuration
├── lib/skills_assessment/
│   ├── constants.rb                # Application constants
│   ├── error.rb                    # Custom error classes
│   ├── llm_client.rb               # Anthropic Claude API client
│   ├── response_cleaner.rb         # JSON response parsing & cleaning
│   ├── prompt_loader.rb            # LLM prompt template loader
│   ├── role_config.rb              # Role configurations and settings
│   ├── role_identifier.rb          # CV role identification logic
│   ├── html_report_generator.rb    # HTML report generation
│   ├── llm_response_logger.rb      # LLM response logging
│   ├── ESCO/                       # ESCO skill taxonomies
│   │   ├── data-scientist-skills.csv
│   │   ├── it-manager-skills.csv
│   │   └── software-architect-skills.csv
│   ├── prompts/                    # LLM prompt templates
│   │   ├── data-scientist-skills-assessment.md
│   │   ├── data-scientist-skills-identification.md
│   │   ├── hard-skills-assessment.md
│   │   ├── it-manager-skills-assessment.md
│   │   ├── leadership-skills-assessment.md
│   │   ├── role-identification.md
│   │   ├── search-query-generation.md
│   │   ├── soft-skills-assessment.md
│   │   ├── software-architect-skills-assessment.md
│   │   ├── web-research-assessment.md
│   │   └── web-search-analysis.md
│   ├── templates/
│   │   └── report.html.erb         # HTML report template
│   └── presenters/                 # Result presentation classes
│       ├── config_presenter.rb
│       ├── essential_skills_presenter.rb
│       ├── readiness_presenter.rb
│       ├── report_presenter.rb
│       └── skills_presenter.rb
├── reports/                        # Output directory for generated reports
└── logs/                           # LLM response logs (when logging enabled)
```

## Requirements

- Ruby 3.3.5+
- Anthropic Claude API key
- PDF format CVs for analysis

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd skills-api
```

2. Install dependencies:
```bash
bundle install
```

3. Configure your environment:
```bash
cp .env.example .env
```

4. Add your Anthropic API key to `.env`:
```
ANTHROPIC_API_KEY=your-api-key-here
```

## Usage

### Analyze CV for a Specific Role

Assess a candidate's CV against requirements for a specific role:

```bash
ruby cli.rb analyze <role> <cv_file> [options]
```

**Parameters:**
- `<role>`: Target role (data-scientist, it-manager, software-architect)
- `<cv_file>`: Path to the CV PDF file

**Options:**
- `-o, --output <path>`: Save output to file (.json or .html)
- `-l, --logging`: Enable LLM response logging for debugging

**Examples:**

Analyze CV and display results in console:
```bash
ruby cli.rb analyze data-scientist CV_John.pdf
```

Generate HTML report:
```bash
ruby cli.rb analyze software-architect CV_Jane.pdf -o jane-report.html
```

Save as JSON with logging enabled:
```bash
ruby cli.rb analyze it-manager CV_Mike.pdf -o mike-assessment.json -l
```

### Identify Relevant Roles

Analyze a CV to identify which roles the candidate is best suited for:

```bash
ruby cli.rb identify-roles <cv_file> [options]
```

**Parameters:**
- `<cv_file>`: Path to the CV PDF file

**Options:**
- `-o, --output <path>`: Save results to JSON file
- `-l, --logging`: Enable LLM response logging

**Examples:**

Identify roles and display in console:
```bash
ruby cli.rb identify-roles CV_Alice.pdf
```

Save role identification results:
```bash
ruby cli.rb identify-roles CV_Alice.pdf -o alice-roles.json
```

## Configuration

### Role Configuration

Each role is configured with:
- Assessment prompts for specific skill areas
- ESCO skills taxonomy
- Maximum token limits for LLM responses
- Custom display titles

Valid roles are defined in `lib/skills_assessment/constants.rb`:
- `data-scientist`
- `it-manager`
- `software-architect`

### LLM Configuration

Configuration for Anthropic Claude API in `lib/skills_assessment/constants.rb`:
- **Model**: claude-sonnet-4-5-20250929
- **Temperature**: 0.1 (deterministic)
- **Default Max Tokens**: 2000
- **API Timeout**: 30 seconds
- **Retry Policy**: 3 attempts with exponential backoff

### ESCO Skills

The project includes ESCO (European Skills, Competences and Qualifications Ontology) skill taxonomies for each role:
- First 50 skills per role are marked as "Essential"
- Remaining skills are marked as "Optional"
- Used to validate and assess candidate skills

## Output Formats

### HTML Reports

Interactive reports with:
- Overall readiness score (0-10)
- Identified skills with proficiency levels
- Missing essential skills
- Visual representation of skill levels
- Career readiness summary

Location: `reports/` directory

### JSON Output

Structured data including:
- Overall readiness assessment
- Identified skills with confidence scores
- Missing essential skills
- Detailed analysis per skill

Example structure:
```json
{
  "overall_readiness": {
    "score": 8.5,
    "summary": "Strong candidate with relevant experience..."
  },
  "identified_skills": [
    {
      "skill_name": "Python",
      "proficiency_level": 9,
      "confidence_score": 0.95,
      "evidence": "..."
    }
  ],
  "missing_essential_skills": [
    "TensorFlow",
    "Data Engineering"
  ]
}
```

## Logging

Enable LLM response logging with the `-l` or `--logging` flag. Logs are saved to:
```
logs/llm/llm_response_YYYYMMDD_HHMMSS.json
```

Useful for:
- Debugging assessment issues
- Analyzing LLM responses
- Understanding skill extraction logic
- Troubleshooting JSON parsing errors

## API Integration

### Anthropic Claude API

The project uses the Anthropic Claude API for:
1. PDF text extraction and OCR
2. CV content analysis
3. Skill identification
4. Role matching
5. Assessment generation

**Environment Variable**: `ANTHROPIC_API_KEY`

API interactions are handled by `lib/skills_assessment/llm_client.rb`.

## Dependencies

- **thor** (1.3+): CLI framework for command structure
- **dotenv** (3.1+): Environment variable management
- **zeitwerk** (2.6+): Code auto-loading
- **base64**: Standard library for encoding
- **rubocop**: Code quality (development only)

## Development

### Code Structure

The codebase uses Zeitwerk for automatic code loading, eliminating the need for manual `require` statements.

### Adding a New Role

1. Add role to `VALID_ROLES` in `constants.rb`
2. Create ESCO skills CSV file in `lib/skills_assessment/ESCO/`
3. Create assessment prompt in `lib/skills_assessment/prompts/`
4. Add role configuration in `role_config.rb`
5. Test with: `ruby cli.rb analyze <new-role> test_cv.pdf -o test.html`

### Customizing Prompts

Prompts are stored in `lib/skills_assessment/prompts/` as markdown files. Edit the prompt text directly to customize assessment behavior.

Each prompt can use template variables:
- `%{cv_text}`: CV content
- `%{esco_skills}`: ESCO skills list

## Error Handling

The tool provides helpful error messages for:
- Invalid role names
- Missing CV files
- Missing API key
- JSON parsing errors
- API communication failures

Errors are color-coded in console output:
- 🔴 Red: Critical errors requiring exit
- 🟡 Yellow: Warnings or important notes
- 🔵 Cyan: Information/processing status
- 🟢 Green: Success

## Troubleshooting

### API Key Issues
```
❌ Error: ANTHROPIC_API_KEY environment variable not set
```
**Solution**: Add `ANTHROPIC_API_KEY=your-key` to `.env` file

### Invalid Role
```
❌ Error: Invalid role 'invalid-role'
```
**Solution**: Use one of the valid roles: `data-scientist`, `it-manager`, `software-architect`

### JSON Parsing Errors
```
❌ Error: Failed to parse LLM response as JSON
```
**Solution**: Enable logging with `-l` flag to inspect the raw LLM response

### CV File Not Found
```
❌ Error: CV file 'path/to/file.pdf' not found
```
**Solution**: Verify the file path is correct and the file exists

## Performance Considerations

- **CV Processing**: Typically 10-30 seconds depending on CV length
- **Role Identification**: Typically 15-45 seconds
- **Concurrent Requests**: The tool processes one CV at a time

## License

[Add license information here if applicable]

## Support

For issues, questions, or contributions, please contact the project maintainers.

## Changelog

### Version 1.0.0 (2025-10-24)
- Initial release
- Support for 3 roles: Data Scientist, IT Manager, Software Architect
- HTML and JSON report generation
- Role identification from CV
- ESCO skills taxonomy integration
- LLM response logging
