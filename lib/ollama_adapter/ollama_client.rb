# frozen_string_literal: true

require "faraday"
require "json"

module OllamaAdapter
  # Handles interaction with the Ollama API, sending prompts and retrieving responses.
  class OllamaClient
    # @param ollama_url [String] The base URL of the Ollama API.
    # @param model_name [String] The model name to use for requests.
    def initialize(ollama_url, model_name)
      @model_name = model_name
      @connection = Faraday.new(
        url: ollama_url,
        headers: { "Content-Type" => "application/json" },
        request: { timeout: 120 }
      )
    end

    # Sends a prompt to the model and retrieves the generated response.
    #
    # @param prompt [String] The prompt to send to the model.
    # @param options [Hash] Additional request options.
    # @return [String] The generated response from the model.
    # @raise [RuntimeError] If the API request fails or returns an error.
    def generate(prompt:, **options)
      params = {
        model: @model_name,
        prompt: prompt,
        stream: false
      }.merge(options)

      response = @connection.post("/api/generate") do |request|
        request.body = JSON.generate(params)
      end

      handle_response(response)
    end

    private

    def handle_response(response)
      unless response.success?
        error = begin
          JSON.parse(response.body)
        rescue StandardError
          {}
        end
        raise "Error #{response.status}: #{error["error"] || response.body}"
      end

      JSON.parse(response.body)["response"]
    end
  end
end
