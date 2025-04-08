# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ollama_adapter"
require "ollama_adapter/ollama_client"
require "ollama_adapter/extractor"
require "ollama_adapter/prompt_builder"

require "minitest/autorun"
