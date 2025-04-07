module OllamaAdapter
  class Extractor
    def initialize(ollama_client)
      @client = ollama_client
    end

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