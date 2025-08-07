# frozen_string_literal: true

require 'csv'

# Handles exporting contract extraction data to CSV format
class CsvExporter
  def self.export(extractions, filename = 'contracts_output.csv')
    CSV.open(filename, 'w') do |csv|
      csv << headers(extractions)
      extractions.each do |extraction|
        csv << format_row(extraction, max_counts(extractions))
      end
    end
  end

  def self.headers(extractions)
    base_headers = base_header_fields
    max_counts = max_counts(extractions)

    base_headers + compensation_headers(max_counts[:compensation]) + signature_headers(max_counts[:signatures])
  end

  def self.format_row(extraction, max_counts)
    base_row = base_row_fields(extraction)
    compensation_row = compensation_row_fields(extraction, max_counts[:compensation])
    signature_row = signature_row_fields(extraction, max_counts[:signatures])

    base_row + compensation_row + signature_row
  end

  def self.max_counts(extractions)
    compensation_max = max_count_for_field(extractions, 'compensation_rates')
    signatures_max = max_count_for_field(extractions, 'signatures')

    {
      compensation: compensation_max,
      signatures: signatures_max
    }
  end

  def self.max_count_for_field(extractions, field_name)
    counts = extractions.map do |extraction|
      extraction[field_name]&.length || 0
    end
    counts.max || 0
  end

  def self.base_header_fields
    %w[
      promisee
      promisor
      contract_type
      effective_date
      termination_notice
      term_length
    ]
  end

  def self.compensation_headers(count)
    headers = []
    (1..count).each do |i|
      headers += [
        "service_#{i}_name",
        "service_#{i}_unit",
        "service_#{i}_rate"
      ]
    end
    headers
  end

  def self.signature_headers(count)
    headers = []
    (1..count).each do |i|
      headers += [
        "signature_#{i}_name",
        "signature_#{i}_title"
      ]
    end
    headers
  end

  def self.base_row_fields(extraction)
    [
      extraction['promisee'],
      extraction['promisor'],
      extraction['contract_type'],
      extraction['effective_date'],
      extraction['termination_notice'],
      extraction['term_length']
    ]
  end

  def self.compensation_row_fields(extraction, max_count)
    row = []
    compensation_rates = extraction['compensation_rates'] || []

    # Add compensation rate data
    compensation_rates.each do |rate|
      row += [rate['service'], rate['unit'], rate['rate']]
    end

    # Pad with empty values if fewer compensation rates than maximum
    row << '' while row.length < max_count * 3
    row
  end

  def self.signature_row_fields(extraction, max_count)
    row = []
    signatures = extraction['signatures'] || []

    # Add signature data
    signatures.each do |signature|
      row += [signature['name'], signature['title']]
    end

    # Pad with empty values if fewer signatures than maximum
    row << '' while row.length < max_count * 2
    row
  end

  private_class_method :max_counts, :max_count_for_field, :base_header_fields, :compensation_headers,
                       :signature_headers, :base_row_fields, :compensation_row_fields, :signature_row_fields
end
