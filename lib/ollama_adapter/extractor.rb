# frozen_string_literal: true

module OllamaAdapter
  # Extracts structured data from unstructured text using a JSON schema and OllamaClient.
  class Extractor
    # @param ollama_client [OllamaAdapter::OllamaClient] The Ollama client for communication with the model.
    def initialize(ollama_client)
      @client = ollama_client
    end

    # Extracts data from text according to the given schema.
    #
    # @param text [String] The input text to analyze.
    # @param schema [Hash{String => Object}] A JSON schema defining the output structure.
    # @return [String] A JSON string with the extracted data.
    def extract(text, schema)
      prompt = PromptBuilder.build_extraction_prompt(text, schema)
      @client.generate(
        prompt: prompt,
        temperature: 0.1,
        max_tokens: 500
      )
    end
  end
end
