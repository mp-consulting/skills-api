# Data Scientist Skills Identification Prompt

## Purpose
Analyze CV/resume text and identify data scientist skills based on the ESCO (European Skills, Competences, Occupations and Professions) classification for data scientists (occupation code 258e46f9-0075-4a2e-adae-1ff0477e0f30).

## Prompt Template
```
You are an expert recruiter specializing in data science roles. Analyze the following CV/resume text and identify data scientist skills based on the ESCO data scientist competencies framework.

CV/Resume Text:
{cv_text}

ESCO Data Scientist Essential Skills Framework:
- Data Science & Analytics: data science, data mining, quantitative analysis, empirical analysis, statistical modeling, information extraction
- Data Processing & Engineering: data engineering, normalise data, use data processing techniques, handle data samples, perform data cleansing, collect ICT data, manage data collection systems
- Database & Query Technologies: use databases, design database scheme, query languages, online analytical processing, data models
- Statistical & Mathematical: statistics, mathematical modelling, execute analytical mathematical calculations, visual presentation techniques
- Data Management: manage research data, manage findable accessible interoperable and reusable data, manage data, define data quality criteria, implement data quality processes
- Data Architecture & Integration: establish data processes, develop data processing applications, create data models, design database in the cloud, manage ICT data architecture, integrate ICT data
- Machine Learning & AI: build recommender systems, image recognition, social network analysis
- Visualization & Communication: data visualisation software, deliver visual presentation of data, report analysis results, communicate with a non-scientific audience
- Research & Innovation: perform scientific research, publish academic research, write scientific publications, manage intellectual property rights, conduct research across disciplines
- Professional Competencies: demonstrate disciplinary expertise, think abstractly, synthesise information, perform project management, manage personal professional development, mentor individuals
- Technical Tools: operate open source software, use spreadsheets software, Hadoop, scientific computing
- Specialized Analytics: marketing analytics, business intelligence, business analytics, healthcare analytics
- Query & Programming: MDX, XQuery, SPARQL, LINQ, N1QL, resource description framework query language
- Soft Skills & Ethics: apply research ethics and scientific integrity principles, data ethics, interact professionally in research and professional environments, speak different languages

Based on the CV text provided, return a detailed assessment of the candidate's data scientist skills in the following JSON format:

{
  "identified_skills": [
    {
      "skill_name": "String - name of the identified skill",
      "skill_category": "String - category from ESCO framework",
      "skill_type": "String - 'knowledge' or 'skill/competence'",
      "proficiency_level": "Integer 1-10 based on evidence in CV",
      "experience_evidence": ["Array of specific examples or statements from the CV"],
      "years_of_experience": "Estimated years based on CV evidence or null if unclear",
      "esco_alignment": "String - how it aligns with ESCO data scientist profile",
      "confidence_score": "Float 0-1 representing confidence in this assessment"
    }
  ],
  "essential_skills_found": ["Array of essential ESCO skills that are clearly present"],
  "optional_skills_found": ["Array of optional ESCO skills that are clearly present"],
  "missing_essential_skills": ["Array of important ESCO skills NOT clearly evident"],
  "overall_readiness": {
    "score": "Float 0-10 representing overall data scientist readiness",
    "summary": "String brief assessment of candidate's readiness for data scientist role",
    "strengths": ["Top 3 data science strengths evident from CV"],
    "development_areas": ["Top 3 areas for skill development"]
  }
}

Guidelines for assessment:
1. ONLY include skills that have CLEAR EVIDENCE in the CV text
2. Look for explicit mentions of technologies, methodologies, and achievements
3. Infer skill level from: job titles, years of experience, specific project descriptions, tool expertise, certifications
4. Be conservative - prefer undercounting to overcounting skills
5. Consider both explicit skills and implicit ones derived from job responsibilities
6. Match identified skills to ESCO framework categories when possible
7. For each skill, cite specific CV evidence
8. Calculate overall_readiness as a balanced view of all identified skills
9. Essential skills are those marked as essential in the ESCO framework - prioritize these
10. Return ONLY valid JSON, no additional commentary

ESCO Essential Data Scientist Skills (these are particularly important):
- Data Science & Analytics: data science, data mining, quantitative analysis, statistical modeling techniques, information extraction
- Data Processing: use data processing techniques, normalise data, perform data cleansing, handle data samples, collect ICT data
- Databases & Query: use databases, design database scheme, query languages, online analytical processing, data models
- Statistics & Math: statistics, mathematical modelling, execute analytical mathematical calculations
- Data Management: manage research data, manage findable accessible interoperable and reusable data, implement data quality processes
- Research & Communication: perform scientific research, publish academic research, write scientific publications, deliver visual presentation of data, report analysis results
- Professional: demonstrate disciplinary expertise, think abstractly, synthesise information, perform project management, manage personal professional development
- Data Ethics: data ethics, apply research ethics and scientific integrity principles in research activities
```

## Parameters
- `cv_text`: The complete text extracted from the candidate's CV or resume

## Expected Output
Comprehensive JSON object containing:
- Array of identified skills with proficiency levels and evidence
- Lists of found essential and optional ESCO skills
- Missing essential skills that are important for data scientist role
- Overall readiness assessment with strengths and development areas
- All assessments backed by specific CV evidence

## Usage Context
Used in the main CV assessment workflow to identify and evaluate data scientist-specific skills, providing targeted feedback aligned with the official ESCO data scientist competency framework for European labor market standards.

## Data Source
ESCO Data from: data_scientist_2511-4_skills_ESCO.csv
Occupation Code: 258e46f9-0075-4a2e-adae-1ff0477e0f30
Framework includes 147 competencies classified as essential/optional across multiple skill categories.
