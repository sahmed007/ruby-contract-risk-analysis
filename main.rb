# frozen_string_literal: true

require 'dotenv/load'
require 'ruby_llm'
require 'async'
require_relative 'lib/extraction_schema'
require_relative 'lib/csv_exporter'

# STEP 1: CONFIGURE RUBYLLM

RubyLLM.configure do |config|
  config.openrouter_api_key = ENV.fetch('OPENROUTER_API_KEY', nil)
end

# STEP 2: EXTRACT INFORMATION FROM CONTRACTS

# Get all PDF files from the contracts directory
contract_files = Dir.glob('contracts/*.pdf')

puts "Found #{contract_files.length} contract(s) to process"

# Process all contracts using async
results = Async do
  tasks = contract_files.map do |file_path|
    Async do
      puts "Processing #{File.basename(file_path)}..."
      chat = RubyLLM.chat(model: 'meta-llama/llama-3.2-3b-instruct')
      response = chat.with_schema(ExtractionSchema).ask('Extract the information from the contract', with: file_path)
      {
        file: file_path,
        content: response.content
      }
    end
  end

  # Wait for all tasks and return results
  tasks.map(&:wait)
end.result

puts "Finished processing #{results.length} contract(s)"

all_extractions = results.flat_map do |result|
  content = result[:content]
  content.is_a?(Array) ? content : [content]
end

# STEP 3: EXPORT TO CSV
puts 'Exporting to CSV...'

# Export all extractions to CSV in the outputs directory
output_file = 'outputs/contracts_output.csv'
CsvExporter.export(all_extractions, output_file)

puts "Done! Results saved to #{output_file}"
