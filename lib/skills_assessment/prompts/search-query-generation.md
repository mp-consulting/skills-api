# Search Query Generation Prompt

## Purpose
Generate targeted search queries to find additional professional information about a person based on their CV information.

## Prompt Template
```
Based on this person's CV information, generate 3-5 targeted search queries to find additional professional information from RELIABLE sources only.

Person Info:
- Name: %{name}
- Email: %{email}

CV Summary (first 1000 characters):
%{cv_summary}

Generate search queries that target RELIABLE professional sources:
- LinkedIn profile (primary)
- Company career pages and team pages
- GitHub repositories and contributions
- Official certifications and credentials
- Professional publications and articles
- Industry association memberships
- Official company press releases

AVOID queries that would return:
- Social media posts
- Personal blogs or websites
- Forums or discussion boards
- Unverified online profiles

Return a JSON array of search query strings optimized for professional verification, like:
["Mickaël PALMA LinkedIn", "Mickaël PALMA GitHub", "Mickaël PALMA site:company.com", "Mickaël PALMA certification site:credly.com"]

Focus ONLY on queries likely to return verifiable professional information from reliable sources. Return valid JSON only.
```

## Parameters
- `name`: The person's name
- `email`: The person's email address
- `cv_summary`: First 1000 characters of the CV text

## Expected Output
Valid JSON array of search query strings optimized for finding professional information.

## Usage Context
Used in the `search_web_for_person` method to generate intelligent search queries for web research enhancement of CV assessments.