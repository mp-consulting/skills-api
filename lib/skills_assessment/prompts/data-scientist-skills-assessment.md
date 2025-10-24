# Data Scientist Skills Assessment Prompt

## Purpose
Analyze CV/resume text to identify and assess a person's data scientist skills using the ESCO framework.

## Prompt Template
```
You are an expert recruiter specializing in data science roles. Analyze the following CV/resume text and identify data scientist skills based on ESCO competencies.

CV/Resume Text:
{cv_text}

%{esco_skills}

Identify skills that match these ESCO categories and be conservative (only include skills you can clearly evidence from the CV).

Return ONLY valid JSON with this exact structure (no additional text):

{
  "identified_skills": [
    {
      "skill_name": "Skill name from ESCO list above",
      "skill_category": "Category from ESCO list",
      "skill_uri": "http://data.europa.eu/esco/skill/...",
      "proficiency_level": 7,
      "experience_years": 5,
      "evidence": "Single line evidence from CV only",
      "confidence_score": 0.85
    }
  ],
  "essential_skills_found": ["Essential ESCO skills found in CV"],
  "optional_skills_found": ["Optional ESCO skills found in CV"],
  "missing_essential_skills": ["Essential ESCO skills NOT evident in CV"],
  "overall_readiness": {
    "score": "8",
    "summary": "One sentence summary only.",
    "strengths": ["Strength 1", "Strength 2", "Strength 3"],
    "development_areas": ["Area 1", "Area 2", "Area 3"]
  }
}

CRITICAL RULES:
1. Identify MAXIMUM 15 skills total
2. evidence field MUST be a STRING (single line, no arrays)
3. Only use skill names from the ESCO list above
4. Match each skill_name to its skill_uri from the ESCO list provided above
5. Return ONLY the JSON object with NO additional text
6. Stop immediately after the final closing brace
```

## Parameters
- `cv_text`: The CV/resume text content (OCR'd from PDF)

## Expected Output
Valid JSON containing identified skills, category summary, and overall readiness assessment aligned with ESCO data scientist competencies.
