# Soft Skills Assessment Prompt

## Purpose
Analyze CV/resume text to identify and assess a person's SOFT/INTERPERSONAL skills using LLM analysis.

## Prompt Template
```
Analyze the following CV/resume text and identify the person's SOFT/INTERPERSONAL skills.
Focus on communication, teamwork, leadership, problem-solving, etc.

CV Text:
{cv_text}

Please return a JSON array of soft skills with the following structure:
[
  {{
    "name": "Communication",
    "level": 8,
    "description": "Ability to convey ideas clearly and effectively",
    "examples": ["Led team presentations", "Mentored junior developers"]
  }}
]

Guidelines:
- Level should be 1-10 based on evidence in the CV
- Only include skills that are demonstrated, not just mentioned
- Provide specific examples from the CV
- Be realistic - don't assume skills without evidence
- Return valid JSON only, no additional text
```

## Parameters
- `cv_text`: The CV/resume text content (limited to 8000 characters)

## Expected Output
Valid JSON array containing soft skills with level, description, and examples from the CV.

## Usage Context
Used in the `assess_soft_skills_llm` method as a fallback to keyword-based assessment when Anthropic Claude API is available.