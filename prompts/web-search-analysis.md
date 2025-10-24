# LLM Knowledge Analysis Prompt

## Purpose
Use LLM knowledge to provide professional insights about a person to enhance skills assessment.

## Prompt Template
```
Based on your training data and knowledge, provide professional insights about %{name} that could enhance a skills assessment.

CRITICAL REQUIREMENTS:
- ONLY include information from RELIABLE, VERIFIED sources in your training data (LinkedIn, company websites, professional publications, official certifications, GitHub, academic papers)
- DO NOT invent, fabricate, or extrapolate any information
- DO NOT assume typical career progression or common skills
- Include CITATIONS for all information using format: [Source: Platform/Company, Year, URL if available]
- Be extremely conservative - only include information that can be directly verified from known sources
- If you have NO specific, verified information about %{name}, return empty arrays

Original CV context:
%{cv_context}

Instructions:
%{search_results}

Extract and provide ONLY verified information from your knowledge base:
1. Additional skills or technologies explicitly documented from reliable sources
2. Professional achievements or projects verified on official platforms
3. Leadership roles or responsibilities stated on company websites or LinkedIn
4. Industry recognition or awards from official announcements
5. Professional network/connections from verified business platforms
6. Recent activities or publications from official sources

Return a JSON object with these categories, including ONLY verified information with citations:
{{
  "additional_skills": ["skill1 [Source: LinkedIn, 2024]"],
  "achievements": ["achievement1 [Source: Company Website, 2023]"],
  "leadership_evidence": ["evidence1 [Source: LinkedIn, 2024]"],
  "recognition": ["award1 [Source: Industry Publication, 2023]"],
  "recent_activity": ["activity1 [Source: GitHub, 2024]"],
  "professional_network": ["connection1 [Source: LinkedIn, 2024]"]
}}

VERIFICATION RULES:
- Only include information from: LinkedIn, company career pages, GitHub, official certifications, academic publications, industry awards
- Reject: personal websites, social media, forums, unverified blogs, Wikipedia, ANY unverified sources
- Every claim must have a specific citation with source, year, and URL if available
- If NO reliable information available in your knowledge base, return EMPTY arrays for all categories
- Do NOT invent, assume, or extrapolate any information
- Return valid JSON only.
```

## Parameters
- `name`: The person's name
- `cv_context`: First 2000 characters of the original CV text
- `search_results`: Instructions for the LLM to provide information

## Expected Output
Valid JSON object with categorized professional insights from LLM knowledge.

## Usage Context
Used in the `llm_search` method to obtain professional insights using LLM knowledge for enhanced CV assessment.