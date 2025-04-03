require 'json'

module OllamaAdapter
  class PromptBuilder
    def self.build_extraction_prompt(text, schema)
      <<~PROMPT
        Извлеки структурированную информацию из текста ниже согласно заданной схеме.
        Текст: """#{text}"""

        Схема извлечения (в JSON):
        #{JSON.pretty_generate(schema)}

        Требования:
        - Возвращай ТОЛЬКО валидный JSON без пояснений
        - Если поле не найдено, используй null
        - Строго соблюдай схему

        Результат:
      PROMPT
    end
  end
end