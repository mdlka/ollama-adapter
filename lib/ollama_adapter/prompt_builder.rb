# frozen_string_literal: true

require "json"

module OllamaAdapter
  # Builds and formats prompts for the LLM.
  class PromptBuilder
    # Builds a prompt to extract structured data from text based on a schema.
    #
    # @param text [String] The unstructured text to extract data from.
    # @param schema [Hash{String => Object}] The schema defining the expected data structure.
    # @return [String] The formatted prompt for the model.
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
