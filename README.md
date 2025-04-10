# OllamaAdapter

OllamaAdapter is a Ruby gem that allows you to interact with the locally hosted Ollama API. It helps extract structured information from unstructured text using JSON schemas.

---

## Features

- Connects to a locally running Ollama instance
- Sends prompts to a specific model
- Extracts structured data using JSON schema

---

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add ollama_adapter
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install ollama_adapter
```

---

## Prerequisites

- Ollama must be installed and running locally
- Default URL: `http://localhost:11434`
- Example model: `qwen2.5:7b`

You can install Ollama from [https://ollama.com](https://ollama.com) and download a model with:

```bash
$ ollama run qwen2.5:7b
```

---

## Usage Example

```ruby
require "ollama_adapter"

# Set up the client and extractor
client = OllamaAdapter::OllamaClient.new("http://localhost:11434", "qwen2.5:7b")
extractor = OllamaAdapter::Extractor.new(client)

# Sample input text
input_text = <<~TEXT
  Hello! My name is Ivan Petrov, my email is ivan.petrov@mail.ru.
  I'm from Moscow, born on 15.03.1990. I work as an engineer at Rostelecom.
  My hobbies are programming, cycling, and traveling.
TEXT

# Define the schema for extraction
schema = {
  type: "object",
  properties: {
    name: { type: "string" },
    birth_year: { type: "integer" }
  },
  required: ["name"]
}

# Perform extraction
begin
  result = extractor.extract(input_text, schema)
  puts "Extraction result:\n#{result}"
rescue OllamaAdapter::Error => e
  puts "Extraction error: #{e.message}"
end
```

Output:

```
Extraction result:
{
  "name": "Ivan Petrov",
  "birth_year": 1990
}
```

### Custom Configuration

You can customize the Ollama API URL and model by providing your own values:

```ruby
client = OllamaAdapter::OllamaClient.new("http://custom-url:port", "another-model")
```

---

## Components

- **`OllamaClient`** — Handles API communication with the Ollama server.
- **`Extractor`** — Uses the LLM to extract structured data from text based on the defined schema.
- **`PromptBuilder`** — Builds and formats prompts for the LLM (used internally for extraction).

---

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
