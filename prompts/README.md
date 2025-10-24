# LLM Prompts for CV Skills Assessment

This directory contains all the prompts used by the CV Skills Assessment system to interact with Anthropic Claude for various analysis tasks.

## Available Prompts

### 1. Hard Skills Assessment (`hard-skills-assessment.md`)
Analyzes CV/resume text to identify and assess technical/hard skills including programming languages, frameworks, tools, databases, and cloud platforms.

**Input**: CV text (limited to 8000 characters)
**Output**: JSON array of skill categories with detailed skill information
**Usage**: `assess_hard_skills_llm()` method

### 2. Soft Skills Assessment (`soft-skills-assessment.md`)
Analyzes CV/resume text to identify and assess interpersonal/soft skills like communication, teamwork, leadership, and problem-solving.

**Input**: CV text (limited to 8000 characters)
**Output**: JSON array of soft skills with levels, descriptions, and examples
**Usage**: `assess_soft_skills_llm()` method

### 3. Leadership Skills Assessment (`leadership-skills-assessment.md`)
Analyzes CV/resume text to identify and assess leadership/management skills including team management, strategic planning, and decision making.

**Input**: CV text (limited to 8000 characters)
**Output**: JSON array of leadership skills with levels, descriptions, and examples
**Usage**: `assess_leadership_skills_llm()` method

### 4. Search Query Generation (`search-query-generation.md`)
Generates targeted search queries to find additional professional information about a person based on their CV.

**Input**: Person name, email, and CV summary (first 1000 characters)
**Output**: JSON array of search query strings
**Usage**: `search_web_for_person()` method for web research enhancement

### 5. Web Search Analysis (`web-search-analysis.md`)
Analyzes collected web search results to extract relevant professional insights that can enhance skills assessment.

**Input**: Person name, original CV context, and web search results
**Output**: JSON object with categorized professional insights
**Usage**: `search_web_for_person()` method for processing web research

### 6. Web Research Assessment (`web-research-assessment.md`)
Generates comprehensive skills assessments using LLM knowledge instead of live web searches, providing reliable evaluation for both known and unknown candidates.

**Input**: Candidate name
**Output**: Complete JSON assessment with person details, skills, and development plan
**Usage**: `assess_from_web_research()` method for name-based assessments

## Prompt Structure

Each prompt file follows a consistent structure:
- **Purpose**: What the prompt does
- **Prompt Template**: The actual prompt text with placeholders
- **Parameters**: Input variables used in the template
- **Expected Output**: Format and structure of the response
- **Usage Context**: Where and how the prompt is used in the code

## Template Variables

The prompts use these template variables that are replaced at runtime:
- `{cv_text}`: CV/resume content
- `{name}`: Person's name
- `{email}`: Person's email address
- `{cv_summary}`: First 1000 characters of CV
- `{cv_context}`: First 2000 characters of CV
- `{search_results}`: Collected web search results
- `{candidate_name}`: Full name of candidate to assess

## JSON Output Format

All prompts that generate structured data return valid JSON without additional text or markdown formatting. The system automatically cleans responses by removing markdown code blocks before parsing.