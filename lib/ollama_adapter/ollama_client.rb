# frozen_string_literal: true

require "faraday"
require "json"

module OllamaAdapter
  class OllamaClient
    def initialize(ollama_url, model_name)
      @model_name = model_name
      @connection = Faraday.new(
        url: ollama_url,
        headers: { "Content-Type" => "application/json" },
        request: { timeout: 120 }
      )
    end

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
