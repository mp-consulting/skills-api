# LLM Prompts Documentation

This document provides comprehensive documentation for all LLM prompts used in the CV Skills Assessment system. These prompts are used to interact with Anthropic Claude for various analysis tasks.

## Overview

The system uses 4 main prompts for CV analysis and role identification:

1. **Role Identification** - Identifies relevant professional roles from a CV
2. **Data Scientist Skills Assessment** - Evaluates data scientist skills using ESCO framework
3. **IT Manager Skills Assessment** - Evaluates IT manager skills using ESCO framework
4. **Software Architect Skills Assessment** - Evaluates software architect skills using ESCO framework

All prompts enforce JSON-only responses for structured data extraction and consistent processing.

---

## 1. Role Identification (`role-identification.md`)

### Purpose
Analyzes a CV to identify which professional roles best match the candidate's background, experience, and skills.

### Input Parameters
- `roles_list`: List of available professional roles (formatted with newlines and dashes)
- `cv_text`: The CV/resume text content (OCR'd from PDF)

### Processing Flow
1. Parses work experience and job titles from CV
2. Reviews key responsibilities and achievements
3. Assesses technical skills mentioned
4. Evaluates industry experience and duration
5. Analyzes leadership and management background
6. Matches candidate profile against available roles

### Output Structure
```json
{
  "identified_roles": [
    {
      "role": "role-name",
      "confidence": 0.95,
      "justification": "Brief explanation of why this role matches",
      "key_evidence": ["achievement 1", "skill 2", "experience 3"]
    }
  ],
  "primary_role": "most-relevant-role",
  "summary": "2-3 sentence overall career profile"
}
```

### Key Rules
- Confidence scores range from 0 to 1
- Only includes roles with confidence > 0.65
- Justification is 1-2 sentences
- Key evidence contains 4-6 specific CV items
- Results ordered by confidence (highest first)

### Use Cases
- Initial CV screening to determine best-fit roles
- Multi-role assessment for candidates
- Career profile generation

### Example Output
```json
{
  "identified_roles": [
    {
      "role": "data-scientist",
      "confidence": 0.92,
      "justification": "5+ years of Python and ML experience with proven track record in data pipeline development",
      "key_evidence": [
        "Led machine learning pipeline development at TechCorp",
        "Python, R, SQL expertise clearly demonstrated",
        "Published 3 research papers on data science",
        "Managed cross-functional analytics team"
      ]
    }
  ],
  "primary_role": "data-scientist",
  "summary": "Highly skilled data scientist with 5+ years of experience in machine learning and data engineering. Strong academic background with published research and proven ability to lead technical teams."
}
```

---

## 2. Data Scientist Skills Assessment (`data-scientist-skills-assessment.md`)

### Purpose
Analyzes CV text to identify and assess a candidate's data scientist skills using the ESCO framework.

### Input Parameters
- `cv_text`: CV/resume text content (limited to 8000 characters)
- `esco_skills`: ESCO skills taxonomy for data scientists (from CSV file)

### ESCO Skills Framework
The assessment uses two tiers of skills:
- **Essential Skills** (first 50 in CSV): Core competencies required for the role
- **Optional Skills** (remaining): Desirable but not mandatory skills

Example essential skills: Data mining, Statistics, Data cleansing, Database design, etc.

### Processing Steps
1. Extracts CV content via OCR from PDF
2. Matches identified skills against ESCO taxonomy
3. Assigns proficiency levels (0-10)
4. Calculates confidence scores (0-1)
5. Identifies missing essential skills
6. Generates overall readiness assessment

### Output Structure
```json
{
  "identified_skills": [
    {
      "skill_name": "Skill name from ESCO list",
      "skill_category": "Category from ESCO list",
      "skill_uri": "http://data.europa.eu/esco/skill/...",
      "proficiency_level": 7,
      "experience_years": 5,
      "evidence": "Single line evidence from CV",
      "confidence_score": 0.85
    }
  ],
  "essential_skills_found": ["List of essential ESCO skills found"],
  "optional_skills_found": ["List of optional skills identified"],
  "missing_essential_skills": ["Essential skills NOT evident in CV"],
  "overall_readiness": {
    "score": "8",
    "summary": "One sentence summary of readiness",
    "strengths": ["Strength 1", "Strength 2", "Strength 3"],
    "development_areas": ["Area 1", "Area 2", "Area 3"]
  }
}
```

### Key Metrics
- **Proficiency Level**: 0-10 scale indicating skill depth
- **Experience Years**: Years of demonstrated experience
- **Confidence Score**: 0-1 indicating LLM confidence in the assessment
- **Overall Score**: 0-10 aggregate readiness score
- **Maximum Skills**: 15 skills per assessment

### Validation Rules
- Only use skill names from provided ESCO list
- Match skill_name to skill_uri from ESCO data
- Evidence must be single-line string (not array)
- Conservative approach: only clear evidence included

### Use Cases
- CV-based role matching for data scientist positions
- Skill gap analysis for hiring decisions
- Career development recommendations
- Interview preparation guidance

### Example Output
```json
{
  "identified_skills": [
    {
      "skill_name": "Data mining",
      "skill_category": "Knowledge",
      "skill_uri": "http://data.europa.eu/esco/skill/25f0ea33-b4a2-4f31-b7b4-7d20e827b180",
      "proficiency_level": 8,
      "experience_years": 5,
      "evidence": "Implemented machine learning models for customer segmentation",
      "confidence_score": 0.92
    }
  ],
  "essential_skills_found": ["Data mining", "Statistics", "Python"],
  "optional_skills_found": ["Hadoop", "Spark"],
  "missing_essential_skills": ["R", "Tableau"],
  "overall_readiness": {
    "score": "8",
    "summary": "Strong data scientist candidate with 5+ years of experience in ML and analytics.",
    "strengths": ["ML expertise", "Python proficiency", "Statistical analysis"],
    "development_areas": ["R programming", "Data visualization tools"]
  }
}
```

---

## 3. IT Manager Skills Assessment (`it-manager-skills-assessment.md`)

### Purpose
Analyzes CV text to identify and assess a candidate's IT management skills using the ESCO framework.

### Input Parameters
- `cv_text`: CV/resume text content (limited to 8000 characters)
- `esco_skills`: ESCO skills taxonomy for IT managers (from CSV file)

### Key Assessment Areas
- IT infrastructure management
- Team leadership and management
- Technical decision-making
- Budget and resource management
- Strategic planning capabilities
- Security and compliance knowledge

### Output Structure
Same as Data Scientist assessment (see above) - includes identified_skills, essential/optional skills, and overall_readiness.

### Skill Categories
The IT Manager assessment focuses on:
- **Management Skills**: Team leadership, project management, budgeting
- **Technical Skills**: Infrastructure, systems, networking
- **Strategic Skills**: Planning, decision-making, governance
- **Soft Skills**: Communication, collaboration, mentoring

### Key Metrics
- **Proficiency Level**: 0-10 for each skill
- **Leadership Experience**: Years managing teams
- **Technical Depth**: Years with technical skills
- **Budget Management**: Experience with IT budgets
- **Maximum Skills**: 15 skills per assessment

### Use Cases
- IT management role matching
- Leadership capability assessment
- Team structure recommendations
- Training and development planning

### Validation Rules
- Only use skill names from provided ESCO list
- Match skill_name to skill_uri from ESCO data
- Evidence must be single-line string
- Conservative scoring approach

---

## 4. Software Architect Skills Assessment (`software-architect-skills-assessment.md`)

### Purpose
Analyzes CV text to identify software architect skills using ESCO competencies. Focuses on top 10-12 most relevant and well-evidenced skills.

### Input Parameters
- `cv_text`: CV/resume text (max 5000 characters)
- `esco_skills`: ESCO skills taxonomy for software architects (from CSV file)

### Key Assessment Focus
- System design and architecture expertise
- Technology stack knowledge
- Technical decision-making capabilities
- Team leadership and technical mentoring
- Software development methodologies
- Cloud and infrastructure design

### Output Structure
```json
{
  "identified_skills": [
    {
      "skill_name": "Skill name from ESCO list",
      "skill_category": "Category",
      "skill_uri": "http://data.europa.eu/esco/skill/...",
      "proficiency_level": 7,
      "experience_years": 5,
      "evidence": "Single line evidence from CV",
      "confidence_score": 0.85
    }
  ],
  "essential_skills_found": ["Top 8 ESCO skills identified"],
  "optional_skills_found": ["2-3 additional skills"],
  "missing_essential_skills": ["1-2 important skills not evident"],
  "overall_readiness": {
    "score": "8",
    "summary": "One sentence summary of architect readiness",
    "strengths": ["Strength 1", "Strength 2"],
    "development_areas": ["Area 1", "Area 2"]
  }
}
```

### Notable Differences
- More selective: focuses on TOP 10-12 skills (vs 15 for others)
- Stricter evidence requirements for architect role
- Emphasis on system design patterns and architecture decisions

### Skill Categories
- **Architecture**: System design, microservices, cloud patterns
- **Technical Leadership**: Decision-making, mentoring, standards
- **Technology**: Programming languages, frameworks, platforms
- **Methodologies**: Agile, DevOps, CI/CD
- **Soft Skills**: Communication, stakeholder management

### Key Metrics
- **Maximum Skills**: 12 skills (most selective)
- **Evidence Quality**: High bar for inclusion
- **Proficiency Depth**: Emphasis on deep expertise (not breadth)
- **Strategic Impact**: Focus on business value of technical decisions

### Use Cases
- Senior architect role matching
- Architecture capability assessment
- Technical strategy planning
- Solution design evaluation

### Validation Rules
- Only use skill names from provided ESCO list
- Match skill_name to skill_uri from ESCO data
- Evidence field: single sentence maximum
- Only include skills with clear CV evidence
- Maximum 12 skills total

---

## Common Features Across All Role Assessments

### ESCO Framework Integration
All role-specific assessments (Data Scientist, IT Manager, Software Architect) use the ESCO framework:
- **ESCO CSV Files**: Located in `lib/skills_assessment/ESCO/`
- **Skill URIs**: Direct links to ESCO database entries
- **Standardized Taxonomy**: Consistent skill categorization
- **International Standard**: Based on European Skills, Competences and Qualifications Ontology

### Skill URI Integration
Each identified skill includes a direct URI link to ESCO:
- Format: `http://data.europa.eu/esco/skill/{uuid}`
- Clickable in HTML reports
- Directs to official ESCO skill definition
- Includes related skills and competencies

### Data Quality Standards
1. **Evidence-Based**: Only skills clearly evidenced in CV
2. **Conservative Approach**: Prefers false negatives over false positives
3. **String Fields**: Evidence is always single-line text
4. **Validation**: All output validated against schema

### Response Format Standards
- **JSON Only**: No markdown or explanation text
- **Structured Output**: Consistent field names across prompts
- **Confidence Scores**: Always 0-1 range
- **Clean Termination**: Stops after final JSON brace

---

## Template Variables

All prompts use these template variables that are replaced at runtime:

| Variable | Type | Used In | Description |
|----------|------|---------|-------------|
| `%{cv_text}` | String | All role assessments | CV/resume content (OCR'd from PDF) |
| `%{esco_skills}` | Text | All role assessments | ESCO skills taxonomy formatted as text |
| `%{roles_list}` | Text | Role identification | Available professional roles list |

---

## Best Practices for Prompt Usage

### 1. CV Text Preparation
- Limit to most relevant sections
- Remove personally identifiable information where possible
- Ensure OCR quality for PDF conversion
- Maximum 8000 characters for skills assessments

### 2. Skill Matching
- Always cross-reference against ESCO list
- Include skill_uri for traceability
- Validate confidence scores are reasonable
- Document evidence source in CV

### 3. Iterative Refinement
- Test with multiple CV samples
- Validate LLM output structure
- Compare across different roles
- Track confidence score distributions

### 4. Error Handling
- Catch JSON parsing errors
- Log raw LLM responses for debugging
- Handle missing skill_uri gracefully
- Validate all required fields present

---

## Extending the System

### Adding a New Role Assessment

1. **Create New Prompt File**: `lib/skills_assessment/prompts/{role-name}-skills-assessment.md`

2. **Define ESCO CSV**: Add corresponding ESCO skills file with columns:
   - skillType
   - preferredLabel
   - relationType (essential/optional)
   - altLabels
   - occupationUri
   - skillUri

3. **Configure Role**: Add to `role_config.rb`:
   ```ruby
   VALID_ROLES = %w[data-scientist it-manager software-architect new-role].freeze
   
   CONFIG = {
     'new-role' => {
       prompt_key: 'new-role-skills-assessment',
       title: 'New Role Skills Assessment',
       max_tokens: 2000
     }
   }
   ```

4. **Update Prompt Structure**: Follow existing format with:
   - Clear purpose statement
   - Template with variable placeholders
   - JSON output structure
   - Critical validation rules

5. **Test Output**: Validate with sample CVs and verify:
   - Correct ESCO skill matching
   - skill_uri populated correctly
   - All required fields present
   - JSON is valid

---

## Troubleshooting

### Issue: Missing skill_uri in Response
**Solution**: Ensure prompt includes matching rule and LLM has access to ESCO data with URIs

### Issue: JSON Parse Error
**Solution**: Check response format, ensure no markdown or extra text after JSON

### Issue: Incorrect Skill Matches
**Solution**: Review ESCO list being provided, check confidence thresholds

### Issue: Confidence Scores Unrealistic
**Solution**: Add more specific evidence requirements, adjust LLM temperature

---

## Version History

- **v1.0** (Oct 2025): Initial release with 4 prompts
- **Features**: Role identification, data scientist assessment, IT manager assessment, software architect assessment
- **ESCO Integration**: Full skill URI support with clickable links in reports
