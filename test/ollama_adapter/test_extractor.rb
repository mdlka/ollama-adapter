# frozen_string_literal: true

require_relative "../test_helper"
require "webmock/minitest"
require "json"

class ExtractorIntegrationTest < Minitest::Test
  OLLAMA_URL = "http://localhost:11434"
  MODEL_NAME = "qwen2.5:3b"

  def setup
    WebMock.allow_net_connect!

    @client = OllamaAdapter::OllamaClient.new(OLLAMA_URL, MODEL_NAME)
    @extractor = OllamaAdapter::Extractor.new(@client)
    @input_text = <<~TEXT
      Здравствуйте! Меня зовут Иван Петров, мой email ivan.petrov@mail.ru.
      Я из Москвы, родился 15.03.1990. Работаю инженером в Ростелеком.
      Мои увлечения: программирование, велоспорт и путешествия.
    TEXT
    @schema = {
      type: "object",
      properties: {
        name: { type: "string" },
        birth_year: { type: "integer" }
      },
      required: ["name"]
    }

    skip_unless_ollama_available
    skip_unless_model_installed
  end

  def test_extract_structured_data_from_text
    result = @extractor.extract(@input_text, @schema)

    assert_kind_of String, result
    parsed_result = JSON.parse(result)

    assert parsed_result.key?("name"), "Result should contain 'name' field"
    assert_equal "Иван Петров", parsed_result["name"]

    if parsed_result.key?("birth_year")
      assert_kind_of Integer, parsed_result["birth_year"]
      assert_equal 1990, parsed_result["birth_year"]
    end
  rescue JSON::ParserError => e
    flunk "Invalid JSON response: #{e.message}\nResponse: #{result}"
  end

  private

  def skip_unless_ollama_available
    response = begin
      Faraday.get("#{OLLAMA_URL}/api/tags")
    rescue StandardError
      nil
    end
    skip "Ollama server not running at #{OLLAMA_URL}" unless response&.success?
  end

  def skip_unless_model_installed
    response = Faraday.get("#{OLLAMA_URL}/api/tags")
    models = JSON.parse(response.body)["models"].map { |m| m["name"] }
    skip "Model #{MODEL_NAME} not installed" unless models.include?(MODEL_NAME)
  end
end
