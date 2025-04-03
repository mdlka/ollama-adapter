require 'faraday'
require 'json'

module OllamaAdapter
    class OllamaClient
        OLLAMA_URL = 'http://localhost:11434'
        MODEL_NAME = 'qwen2.5:3b'

        def initialize
            @connection = Faraday.new(
            url: OLLAMA_URL,
            headers: {'Content-Type' => 'application/json'},
            request: { timeout: 120 }
            )
        end

        def generate(prompt:, **options)
            params = {
            model: MODEL_NAME,
            prompt: prompt,
            stream: false
            }.merge(options)

            response = @connection.post('/api/generate') do |request|
            request.body = JSON.generate(params)
            end

            handle_response(response)
        end

        private

        def handle_response(response)
            unless response.success?
            error = JSON.parse(response.body) rescue {}
            raise "Error #{response.status}: #{error['error'] || response.body}"
            end

            JSON.parse(response.body)['response']
        end
    end
end