# Hard Skills Assessment Prompt

## Purpose
Analyze CV/resume text to identify and assess a person's HARD/TECHNICAL skills using LLM analysis.

## Prompt Template
```
Analyze the following CV/resume text and identify the person's HARD/TECHNICAL skills.
Focus on programming languages, frameworks, tools, databases, cloud platforms, etc.

CV Text:
{cv_text}

Please return a JSON array of skill categories with the following structure:
[
  {{
    "category": "Programming Languages",
    "skills": [
      {{
        "name": "Python",
        "level": 8,
        "experience_years": 5,
        "certifications": ["Python Certified"],
        "projects": ["Web App", "Data Analysis Tool"]
      }}
    ]
  }}
]

Guidelines:
- Level should be 1-10 based on proficiency evidence
- experience_years should be estimated from the CV
- Only include skills that are clearly demonstrated or mentioned
- Be conservative with levels - require evidence of actual usage
- Return valid JSON only, no additional text or wrapper objects
```

## Parameters
- `cv_text`: The CV/resume text content (limited to 8000 characters)

## Expected Output
Valid JSON array containing skill categories with detailed skill information including level, experience years, certifications, and projects.

## Usage Context
Used in the `assess_hard_skills_llm` method as a fallback to keyword-based assessment when Anthropic Claude API is available.