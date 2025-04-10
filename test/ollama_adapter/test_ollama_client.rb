# frozen_string_literal: true

require_relative "../test_helper"
require "webmock/minitest"
require "faraday"

class OllamaClientTest < Minitest::Test
  def setup
    WebMock.enable!
    WebMock.disable_net_connect!

    @ollama_url = "http://localhost:11434"
    @model_name = "test-model"
    @client = OllamaAdapter::OllamaClient.new(@ollama_url, @model_name)
  end

  def teardown
    WebMock.reset!
  end

  def test_generate_with_valid_prompt_returns_generated_text
    stub_request(:post, "#{@ollama_url}/api/generate")
      .with(
        body: {
          model: @model_name,
          prompt: "Test prompt",
          stream: false
        }.to_json
      )
      .to_return(
        status: 200,
        body: { response: "Generated text" }.to_json
      )

    result = @client.generate(prompt: "Test prompt")
    assert_equal "Generated text", result
  end

  def test_generate_with_additional_options_returns_generated_text
    stub_request(:post, "#{@ollama_url}/api/generate")
      .with(
        body: {
          model: @model_name,
          prompt: "Test prompt",
          stream: false,
          temperature: 0.7,
          max_tokens: 500
        }.to_json
      )
      .to_return(
        status: 200,
        body: { response: "Generated with options" }.to_json
      )

    result = @client.generate(prompt: "Test prompt", temperature: 0.7, max_tokens: 500)
    assert_equal "Generated with options", result
  end

  def test_generate_when_server_returns_error_raises_runtime_error
    stub_request(:post, "#{@ollama_url}/api/generate")
      .to_return(
        status: 500,
        body: { error: "Server error" }.to_json
      )

    error = assert_raises(RuntimeError) do
      @client.generate(prompt: "Test prompt")
    end
    assert_match(/Error 500: Server error/, error.message)
  end

  def test_generate_when_invalid_json_response_raises_runtime_error
    stub_request(:post, "#{@ollama_url}/api/generate")
      .to_return(
        status: 500,
        body: "Invalid JSON"
      )

    error = assert_raises(RuntimeError) do
      @client.generate(prompt: "Test prompt")
    end
    assert_match(/Error 500: Invalid JSON/, error.message)
  end
end
