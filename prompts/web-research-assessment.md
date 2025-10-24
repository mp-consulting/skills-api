# Web Research Assessment Prompt

## Purpose
Generate a comprehensive professional skills assessment based ONLY on verified information from reliable sources about a candidate. If no reliable information is available, return an empty assessment.

## Prompt Template
```
Based on VERIFIED information from reliable sources about %{candidate_name}, create a comprehensive professional skills assessment.

CRITICAL REQUIREMENTS:
- ONLY include information that can be VERIFIED from reliable, publicly available sources (LinkedIn, company websites, professional publications, official certifications, GitHub repositories with clear attribution)
- DO NOT invent, fabricate, estimate, or assume any skills, experiences, or achievements
- DO NOT create "realistic" assessments for typical professionals
- If you have NO reliable, verifiable information about %{candidate_name}, return an EMPTY assessment with no skills
- Include CITATIONS for ALL specific claims, using format: [Source: Company/Platform, Year, URL if available]
- Be extremely conservative - only include skills with concrete evidence
- For unknown individuals, return empty skills arrays rather than estimates

Generate a detailed skills assessment with the following structure:

{{
  "person": {{
    "id": "llm-assessed-person",
    "name": "%{candidate_name}",
    "email": "",
    "department": "Information Unavailable",
    "role": "Information Unavailable"
  }},
  "assessment": {{
    "date": "2025-10-17",
    "assessor": "Verified Source Analysis Only",
    "overall_rating": 0,
    "reliability_note": "Assessment based ONLY on verified information from reliable sources. No information available for this individual."
  }},
  "skills": {{
    "hard": [],
    "soft": [],
    "leadership": []
  }},
  "development_plan": {{
    "goals": []
  }}
}}

Guidelines:
- ONLY include skills and experiences that can be VERIFIED from actual sources
- Add "citations" array to each skill with SPECIFIC, VERIFIABLE source references
- For well-known individuals: Base assessment ONLY on DOCUMENTED, VERIFIED career achievements
- For others: Return EMPTY assessment - do not create hypothetical skills
- Include 3-5 hard skill categories with 1-3 skills each (ONLY if VERIFIABLE from sources)
- Include 3-5 soft skills with SPECIFIC examples (ONLY if EVIDENCED from sources)
- Include 2-4 leadership skills with CONCRETE examples (ONLY if DEMONSTRATED from sources)
- Level should be 1-10 based on DEMONSTRATED expertise - be extremely conservative
- experience_years should be based on VERIFIED career history only
- Include relevant certifications and projects ONLY if they can be VERIFIED from official sources
- Calculate overall_rating as the average of all VERIFIED skill levels (0 if no skills)
- If no reliable information exists, return empty arrays and note this in reliability_note
- Return valid JSON only, no additional text
```
```

## Parameters
- `candidate_name`: The full name of the candidate to assess

## Expected Output
Valid JSON object containing complete skills assessment with person details, assessment metadata, categorized skills, and development goals.

## Usage Context
Used in the `assess_from_web_research` method to generate comprehensive assessments using LLM knowledge instead of live web searches, providing reliable and fast evaluation for both known and unknown candidates.