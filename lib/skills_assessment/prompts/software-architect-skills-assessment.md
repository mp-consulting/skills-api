# Software Architect Skills Assessment Prompt

## Purpose
Analyze CV/resume text to identify software architect skills using ESCO competencies.

## Prompt Template
```
You are an expert recruiter specializing in software architecture roles.

TASK: Analyze this CV and identify software architect skills from the ESCO framework provided below.
Identify the TOP 10-12 skills only - focus on the most prominent and well-evidenced competencies.

%{esco_skills}

CV TEXT:
{cv_text}

OUTPUT FORMAT - Return ONLY valid JSON, no other text:
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
  "missing_essential_skills": ["1-2 important ESCO skills not evident"],
  "overall_readiness": {
    "score": "8",
    "summary": "One sentence summary of architect readiness.",
    "strengths": ["Strength 1", "Strength 2"],
    "development_areas": ["Area 1", "Area 2"]
  }
}

STRICT RULES:
1. Only use skill names from the ESCO list provided above
2. Match each skill_name to its skill_uri from the ESCO list provided above
3. Identify MAXIMUM 12 skills total
4. evidence field must be a STRING (not array) with single sentence max
5. Only include skills with clear CV evidence
6. Return ONLY the JSON object, no markdown or extra text
7. Stop immediately after final closing brace
```

## Parameters
- `cv_text`: The CV/resume text (max 5000 chars)
- `esco_skills`: Reference list of ESCO software architect skills

## Expected Output
Valid JSON with skills identified from ESCO framework, category summary, and overall readiness score.
