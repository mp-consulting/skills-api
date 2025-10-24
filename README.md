# Skills Assessment API# CV Skills Assessment Tool



A sophisticated Ruby CLI application for analyzing CVs/resumes and identifying professional skills across multiple role perspectives. Uses Claude AI for intelligent CV analysis with role identification orchestration and HTML report generation.A Ruby application that analyzes CVs/resumes to assess hard, soft, and leadership skills using both keyword matching and Anthropic Claude LLM analysis.



## 🎯 Features## Features



### Core Functionality- **Dual Input Modes**:

- **Two-Stage CV Analysis**  - CV-based assessment: Process PDF resumes with text extraction

  1. **Role Identification** - Automatically detect relevant professional roles from CV  - Research-based assessment: Generate skills assessment from LLM knowledge only

  2. **Role-Specific Assessment** - Detailed skill analysis from role perspective- **PDF Processing**: Extracts text from PDF CVs

- **Multi-language Support**: Handles French and English CVs

- **Multiple Role Support**- **Dual Assessment Modes**:

  - Data Scientist  - LLM-powered assessment (Anthropic Claude 3.5 Sonnet) - Primary

  - IT Manager  - Keyword-based assessment (fallback)

  - Software Architect- **LLM Knowledge Snapshots**: Direct assessment generation using LLM's knowledge base

- **Structured Output**: JSON format matching the skills assessment schema

- **Intelligent Analysis**- **Environment Configuration**: Secure API key management via `.env` file

  - ESCO (European Skills/Competences/Occupations) framework alignment

  - Confidence scoring with detailed justifications## Setup

  - Evidence extraction from CV

  - Skill categorization and proficiency levels### 1. Install Dependencies



- **Report Generation**```bash

  - Interactive HTML reports with styled outputgem install pdf-reader anthropic dotenv nokogiri

  - Professional skill summaries```

  - Readiness assessment scores

  - JSON export for programmatic use### 2. Configure Environment



### Recent EnhancementsCreate a `.env` file in the project root:

- ✅ Role identification via CLI (`identify-roles` command)

- ✅ Two-stage analysis orchestration```bash

- ✅ Presenter Pattern for clean architecture# Anthropic API Key for Claude LLM assessment

- ✅ 87% reduction in HtmlReportGenerator complexity# Get your key from: https://console.anthropic.com/

- ✅ Service-oriented architecture with proper error handlingANTHROPIC_API_KEY=your-anthropic-api-key-here

```

## 📋 Requirements

### 3. Prepare CV (Optional)

- Ruby 3.3.5 (managed with asdf)

- BundlerFor CV-based assessment, place your PDF CV in the project directory.

- Anthropic API Key (Claude AI)

### 4. Run the Assessment

## 🚀 Installation

#### Option 1: Assess from CV file

1. **Clone the repository**```bash

```bashruby cv_skills_assessor.rb mickael_palma_cv.pdf

git clone <repository>```

cd skills-api

```#### Option 2: Assess from web research only

```bash

2. **Install Ruby (using asdf)**ruby cv_skills_assessor.rb --name "Mickaël Palma"

```bash```

asdf install

```The script will automatically:

- Load configuration from `.env`

3. **Install dependencies**- For CV files: Process the PDF and extract skills using Claude 3.5 Sonnet

```bash- For names: Conduct comprehensive web research and generate skills assessment

bundle install- Output detailed JSON assessment results

```

## Current Status ✅

4. **Configure environment**

```bash- ✅ PDF text extraction working

cp .env.example .env- ✅ Person information extraction (name, email)

# Edit .env and add your Anthropic API key- ✅ LLM-powered hard skills assessment

echo "ANTHROPIC_API_KEY=your-key-here" >> .env- ✅ LLM-powered soft skills assessment

```- ✅ LLM-powered leadership skills assessment

- ✅ Environment configuration with `.env`

## 💻 Usage- ✅ French language support

- ✅ Web research integration with LLM reasoning

### Command: `identify-roles`- ✅ **Research-based assessment (name-only input)**

Identify relevant professional roles from a CV.- ✅ Structured JSON output

- ✅ Overall rating calculation

```bash- ✅ Robust error handling and fallbacks

# Display role identification results

ruby cli.rb identify-roles CV_File.pdf## Output Format



# Save results to JSON fileThe tool generates comprehensive JSON assessments:

ruby cli.rb identify-roles CV_File.pdf -o roles.json

**Key Features:**

# Enable LLM logging- **Person Information**: Extracted from CV or generated for name-based assessments

ruby cli.rb identify-roles CV_File.pdf -l- **Assessment Metadata**: Date, assessor type, overall rating

```- **Skills Breakdown**: Hard, soft, and leadership skills with detailed analysis

- **Explanation Field**: LLM provides reasoning for assessment results, especially when no verified information is available

**Output Example:**- **Development Plan**: Placeholder for future enhancement

```

📋 Career Summary:```json

Seasoned technology executive with 20+ years of experience...```json

{

🎯 Primary Role Match:  "person": {

it-manager    "name": "Mickaël PALMA",

    "email": "mickael.palma@mac.com",

✅ Identified Roles:    "role": ""

  • it-manager (95.0%)  },

    Extensive experience as CTO and technical leadership...  "assessment": {

  • software-architect (92.0%)    "date": "2025-10-17",

    Deep technical expertise in architecture design...    "assessor": "Automated CV Analysis with Web Research",

  • data-scientist (68.0%)    "overall_rating": 6.8,

    Experience managing data teams...    "explanation": "I do not have any specific, verified information about Mickael PALMA in my training data from reliable sources such as LinkedIn, company websites, professional publications, official certifications, GitHub, or academic papers. Without access to real-time data or specific verified records about this individual, I cannot provide any professional insights that meet the critical requirements for reliability and verification you've specified.\n\nTo obtain accurate professional information about Mickael PALMA, I recommend:\n1. Directly reviewing their LinkedIn profile\n2. Checking their GitHub account if they have one\n3. Searching for publications in academic databases\n4. Reviewing company websites where they may have worked\n5. Looking for professional certifications through official certification bodies"

```  },

  "skills": {

### Command: `analyze`    "hard": [

Perform detailed role-specific skill assessment.      {

        "category": "Programming Languages",

```bash        "skills": [

# Analyze CV for specific role          {

ruby cli.rb analyze data-scientist CV_File.pdf            "name": "Ruby",

            "level": 8,

# Save to HTML report            "experience_years": 10,

ruby cli.rb analyze data-scientist CV_File.pdf -o report.html            "certifications": [],

            "projects": ["API Development", "Web Applications"]

# Save to JSON          }

ruby cli.rb analyze data-scientist CV_File.pdf -o report.json        ]

      }

# Enable logging    ],

ruby cli.rb analyze data-scientist CV_File.pdf -o report.html -l    "soft": [

```      {

        "name": "Leadership",

**Output Example:**        "level": 9,

```        "description": "Proven ability to lead and inspire technical teams",

📊 Overall Score: 8/10        "examples": ["CTO at multiple companies", "Led tribe of 40+ people"]

📝 Summary: Highly qualified senior data scientist...      }

    ],

✅ Identified Skills (15):    "leadership": [

  • Machine Learning - Level: 8/10, Confidence: 95%      {

  • Deep Learning - Level: 7/10, Confidence: 92%        "name": "Team Management",

  • Python Programming - Level: 8/10, Confidence: 90%        "level": 9,

  ...        "description": "Extensive experience managing technical teams",

        "examples": ["Scaled data team to 40+ people", "Managed Scrum teams"]

⚠️  Missing Essential Skills (3):      }

  ○ Advanced Statistical Modeling    ]

  ○ Time Series Analysis  }

  ...}

``````

```

## 📁 Project Structure

## Assessment Methods

```

skills-api/### LLM Assessment (Primary)

├── lib/skills_assessment/- **Model**: Claude 3.5 Sonnet

│   ├── role_identifier.rb              # Role identification service- **Capabilities**:

│   ├── html_report_generator.rb        # HTML report generation  - Intelligent skill detection with context

│   ├── llm_client.rb                   # Claude API integration  - Evidence-based proficiency scoring (1-10 scale)

│   ├── response_cleaner.rb             # JSON response parsing  - Specific examples from CV text

│   ├── prompt_loader.rb                # Prompt template loading  - French language understanding

│   ├── role_config.rb                  # Role configuration service  - Leadership and soft skills analysis

│   ├── error.rb                        # Custom exception classes  - **LLM Knowledge Snapshots**: Direct assessment generation for any candidate name

│   ├── llm_response_logger.rb          # LLM response logging

│   ├── presenters/                     # Presenter Pattern classes### Keyword Matching (Fallback)

│   │   ├── config_presenter.rb- Pattern-based skill identification

│   │   ├── readiness_presenter.rb- Frequency-based level assignment

│   │   ├── skills_presenter.rb- Works without API configuration

│   │   ├── essential_skills_presenter.rb

│   │   └── report_presenter.rb## Debugging and Logging

│   ├── prompts/                        # Prompt templates

│   │   ├── role-identification.md### LLM Response Logs

│   │   ├── data-scientist-skills-assessment.md

│   │   ├── it-manager-skills-assessment.mdThe system automatically logs all LLM API responses to files for debugging and analysis:

│   │   └── software-architect-skills-assessment.md

│   ├── templates/- **Location**: `llm_logs/` directory (created automatically)

│   │   └── report.html.erb             # HTML report template- **Format**: JSON files with timestamps

│   └── ESCO/                           # ESCO skill definitions- **Contents**: Raw API responses, prompts, parameters, and extracted text

│       ├── data-scientist-skills.csv

│       ├── it-manager-skills.csv#### Analyzing Logs

│       └── software-architect-skills.csv

├── cli.rb                              # Main CLI interfaceUse the provided analysis script:

├── config/

│   └── zeitwerk.rb                     # Class autoloading configuration```bash

├── lib/skills_assessment/constants.rb  # Constants and configurationruby analyze_llm_logs.rb

└── Gemfile                             # Ruby dependencies```

```

This will show a summary of all logged LLM interactions including:

## 🏗️ Architecture- Timestamps and model information

- Token usage statistics

### Design Patterns Used- Response previews

- Success/failure status

1. **Service Objects**

   - `RoleIdentifier` - Role identification service#### Log File Structure

   - `RoleConfig` - Configuration management

   - `LLMResponseLogger` - Logging serviceEach log file contains:

```json

2. **Presenter Pattern**{

   - Separates data presentation from rendering  "timestamp": "2025-10-17T18:05:58+01:00",

   - Five specialized presenters for different data aspects  "model": "claude-sonnet-4-5-20250929",

   - Clean template interface  "max_tokens": 1500,

  "temperature": 0.1,

3. **Error Hierarchy**  "prompt_preview": "Based on your training data...",

   - Custom exception classes with context  "raw_response": { /* Full API response */ },

   - Proper error propagation and handling  "response_text": "Extracted text content",

  "success": true

4. **Query Objects** (Planned)}

   - `ESCOSkillsLoader` - ESCO skills management```



### SOLID PrinciplesThis feature helps with:

- Troubleshooting API issues

✅ **Single Responsibility** - Each class has one reason to change- Understanding LLM behavior

✅ **Open/Closed** - Open for extension, closed for modification- Analyzing response quality

✅ **Liskov Substitution** - Presenters follow consistent interface- Debugging parsing problems
✅ **Interface Segregation** - Classes expose only necessary methods
✅ **Dependency Inversion** - Depends on abstractions, not concrete classes

### Two-Stage Analysis Workflow

```
┌──────────────────────────────────────────┐
│  Stage 1: Role Identification            │
│  - Analyze CV                            │
│  - Identify relevant roles               │
│  - Return confidence scores              │
└──────────────┬───────────────────────────┘
               │
               ▼
        ┌──────────────┐
        │ Select Roles │
        └──────┬───────┘
               │
               ▼
┌──────────────────────────────────────────┐
│  Stage 2: Role-Specific Assessment       │
│  - For each role:                        │
│  - Load role-specific prompt             │
│  - Analyze skills                        │
│  - Generate reports                      │
└──────────────────────────────────────────┘
```

## 📊 Analysis Output

### HTML Reports Include:
- Professional score (0-10)
- Overall assessment summary
- Identified skills with proficiency levels
- Confidence scores for each skill
- Evidence from CV
- Strengths and development areas
- Essential skills found
- Missing essential skills
- Optional skills matched

### JSON Output Includes:
- Role identification data
- Confidence scores
- Career profile summary
- Key evidence per role
- Detailed skill assessments
- Proficiency levels and experience years

## 🔑 Key Technologies

- **Ruby 3.3.5** - Programming language
- **Thor 1.4.0** - CLI framework
- **Zeitwerk 2.7.3** - Class autoloading
- **Anthropic Claude AI** - LLM for CV analysis
- **ERB** - HTML templating
- **CSV** - ESCO skills data format

## 📝 Environment Variables

```bash
# Required
ANTHROPIC_API_KEY=your-anthropic-api-key

# Optional
LLM_LOGGING=true  # Enable detailed LLM response logging
```

## 🧪 Testing

### Manual Testing
Test all three roles:
```bash
ruby cli.rb analyze data-scientist CV_File.pdf -o report_ds.html
ruby cli.rb analyze it-manager CV_File.pdf -o report_it.html
ruby cli.rb analyze software-architect CV_File.pdf -o report_sa.html
```

### Role Identification
```bash
ruby cli.rb identify-roles CV_File.pdf
ruby cli.rb identify-roles CV_File.pdf -o roles.json
```

## 📈 Code Quality Metrics

| Metric | Value |
|--------|-------|
| HtmlReportGenerator Reduction | 87.5% |
| Average Method Length | 3-5 lines |
| Average Class Size | 30-70 lines |
| Cyclomatic Complexity | Low |
| SOLID Compliance | ✅ 100% |

## 🔄 Recent Refactoring

### Phase 1: Foundation ✅
- Error hierarchy
- RoleConfig service
- LLMResponseLogger

### Phase 2: Design Patterns ✅
- Presenter Pattern (5 classes)
- HtmlReportGenerator refactor (87% reduction)
- Role Identification feature

### Phase 3: Planned
- ResponseCleaner strategies (Strategy Pattern)
- PromptLoader unification
- ESCOSkillsLoader Query Object

## 📚 Documentation

- [Refactoring Summary](./REFACTORING_SUMMARY.md) - Complete refactoring overview
- [Phase 2.2 Complete](./PHASE_2_2_COMPLETE.md) - HtmlReportGenerator refactoring
- [Role Identification Feature](./ROLE_IDENTIFICATION_FEATURE.md) - Role identification details
- [Refactoring Analysis](./REFACTORING_ANALYSIS.md) - Initial analysis document

## 🐛 Error Handling

The application includes comprehensive error handling:

- **ResponseParseError** - JSON parsing failures
- **ConfigError** - Configuration issues
- **ValidationError** - Input validation
- **FileError** - File operation failures
- **LLMError** - API communication issues

Errors include context and helpful messages for debugging.

## 🚀 Future Enhancements

- [ ] Batch CV analysis for multiple candidates
- [ ] Analysis orchestrator for full two-stage workflow
- [ ] Caching of role identification results
- [ ] Machine learning model for role prediction
- [ ] REST API endpoints
- [ ] Database integration for report history
- [ ] Comparison reports between roles

## 📄 License

[Your License Here]

## 👥 Contributing

[Contributing Guidelines]

## 📧 Support

For issues or questions, please [contact information]

---

## Quick Start Example

```bash
# 1. Identify roles
ruby cli.rb identify-roles my_cv.pdf -o roles.json

# 2. View identified roles and choose one
# Output shows: it-manager (95%), software-architect (92%), data-scientist (68%)

# 3. Analyze for chosen role
ruby cli.rb analyze it-manager my_cv.pdf -o report.html

# 4. Open report in browser
open report.html
```

## 🎓 Learning Resources

This project demonstrates:
- Clean Code principles
- SOLID design patterns
- Ruby best practices
- Service-oriented architecture
- Presenter Pattern implementation
- Error handling strategies
- CLI application development
- Integration with external APIs

---

**Last Updated**: October 24, 2025
**Project Status**: Active Development
**Current Phase**: Phase 2 - Design Pattern Implementation
