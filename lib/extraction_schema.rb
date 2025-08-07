# frozen_string_literal: true

require 'ruby_llm/schema'

# Schema for extracting information from a contract
class ExtractionSchema < RubyLLM::Schema
  string :promisee, description: 'Promisee of the contract', required: true
  string :promisor, description: 'Promisor of the contract', required: true
  string :contract_type, description: 'Type of contract', required: true
  string :effective_date, description: 'Effective date of the contract', required: true
  string :termination_notice, description: 'Termination notice period'
  string :term_length, description: 'Contract duration or term length'

  array :compensation_rates, description: 'List of compensation rates for services' do
    object do
      string :service, description: 'Name of the service or item'
      string :unit, description: 'Unit of measurement for the service'
      string :rate, description: 'Rate or price for the service'
    end
  end

  array :signatures, description: 'List of signatures with name and title' do
    object do
      string :name, description: 'Name of the signer'
      string :title, description: 'Title or position of the signer'
    end
  end
end
