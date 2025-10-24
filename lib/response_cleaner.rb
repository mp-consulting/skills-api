# lib/response_cleaner.rb
module SkillsAssessment
  class ResponseCleaner
    def clean(response)
      # Ensure response is a string
      response = response.to_s if response

      return "" unless response.is_a?(String) && !response.empty?

      # First, try to extract JSON from markdown code blocks
      json_match = response.match(/```(?:json)?\s*(\{.*\}|\[.*\])\s*```/m)
      return json_match[1] if json_match

      # If no code block found, clean the response
      cleaned = response
        .gsub(/```json\s*/, '')  # Remove opening code block
        .gsub(/```\s*$/, '')      # Remove closing code block
        .gsub(/^#+\s+.*\n/, '')  # Remove markdown headers
        .gsub(/^##+\s+.*\n/, '') # Remove markdown subheaders
        .gsub(/^\*\s+.*\n/, '')  # Remove markdown list items
        .gsub(/^-+\s+.*\n/, '')  # Remove markdown list items with dashes
        .gsub(/^\d+\.\s+.*\n/, '') # Remove numbered list items
        .gsub(/\*\*.*?\*\*/, '')  # Remove bold markdown
        .gsub(/\*.*?\*/, '')     # Remove italic markdown
        .gsub(/^>.*\n/, '')      # Remove blockquotes
        .gsub(/^.*\*\*Note:\*\*.*\n/, '') # Remove note lines
        .gsub(/^.*Note:.*\n/, '') # Remove note lines (case insensitive)
        .strip

      # Try to find JSON object/array in the cleaned response
      json_start = cleaned.index('{') || cleaned.index('[')
      json_end = cleaned.rindex('}') || cleaned.rindex(']')

      if json_start && json_end && json_start < json_end
        cleaned = cleaned[json_start..json_end]
      end

      # Repair incomplete JSON by closing unclosed structures
      cleaned = repair_incomplete_json(cleaned)

      cleaned.strip
    end

    private

    def repair_incomplete_json(json_str)
      # Count opening and closing braces/brackets
      open_braces = json_str.count('{') - json_str.count('}')
      open_brackets = json_str.count('[') - json_str.count(']')

      # Close any unclosed structures
      json_str += '}' * open_braces if open_braces > 0
      json_str += ']' * open_brackets if open_brackets > 0

      json_str
    end
  end
end
