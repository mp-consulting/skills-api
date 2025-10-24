# Leadership Skills Assessment Prompt

## Purpose
Analyze CV/resume text to identify and assess a person's LEADERSHIP/MANAGEMENT skills using LLM analysis.

## Prompt Template
```
Analyze the following CV/resume text and identify the person's LEADERSHIP/MANAGEMENT skills.
Focus on team management, strategic planning, decision making, mentoring, etc.

CV Text:
{cv_text}

Please return a JSON array of leadership skills with the following structure:
[
  {{
    "name": "Team Management",
    "level": 7,
    "description": "Leads and manages team members effectively",
    "examples": ["Managed a team of 5 developers", "Conducted performance reviews"]
  }}
]

Guidelines:
- Level should be 1-10 based on evidence of actual leadership experience
- Only include skills demonstrated through concrete examples
- Look for evidence of managing people, projects, or strategic decisions
- Be conservative - titles alone don't prove leadership capability
- Return valid JSON only, no additional text
```

## Parameters
- `cv_text`: The CV/resume text content (limited to 8000 characters)

## Expected Output
Valid JSON array containing leadership skills with level, description, and concrete examples from the CV.

## Usage Context
Used in the `assess_leadership_skills_llm` method as a fallback to keyword-based assessment when Anthropic Claude API is available.