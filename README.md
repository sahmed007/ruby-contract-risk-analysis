# Contract Risk Analysis with Ruby

A practical real-world example of automating contract processing with AI using Ruby.

This repository contains a real world example of how to use RubyLLM to extract information from contracts, enrich it with generated data, and export it to a CSV file.

## Installation

Clone the repo and run `bundle install` to install dependencies.

```bash
bundle install
```

## Usage

These examples use OpenRouter API for LLM calls. You will need to set up an OpenRouter API key by creating a `.env` file using the `.env.example` as a template.

If you would like to use a different LLM provider, you can modify the configuration in the `main.rb` file to use a different LLM provider along with the model of your choice as well. In this example, the `meta-llama/llama-3.2-3b-instruct` model is used.

The LLM calls are made using the [RubyLLM](https://github.com/crmne/ruby_llm) gem. To see the complete list of models, you can go [here](https://rubyllm.com/guides/available-models).

In the `main.rb` file, you will see a step by step process of extracting information from contracts and exporting it to a CSV file. Simply run with `ruby main.rb` to see the results.

## Contributing

Pull requests are always welcome.

## License

[MIT](https://choosealicense.com/licenses/mit/)