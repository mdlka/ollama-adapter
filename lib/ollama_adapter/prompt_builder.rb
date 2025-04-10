# frozen_string_literal: true

require "json"

module OllamaAdapter
  class PromptBuilder
    def self.build_extraction_prompt(text, schema)
      <<~PROMPT
        Extract the structured information from the text below according to the specified scheme.
        Text: """#{text}"""

        Extraction scheme (in JSON):
        #{JSON.pretty_generate(schema)}

        Requirements:
        - Return ONLY valid JSON without explanation
        - If the field is not found, use null
        - Strictly follow the scheme.

        Result:
      PROMPT
    end
  end
end
