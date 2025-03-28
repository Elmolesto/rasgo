# lib/converter.rb

module CSVExtension
  class Converter
    def self.clean_and_convert(value)
      value.to_s.strip.gsub(',', '.').gsub(/[^\d.]/, '').to_f
    rescue => e
      raise "Error: #{e.message}"
    end

    def self.canto_value(value)
      return '1' if value&.include?('CantoD')
      return '2' if value&.include?('CantoG')
      ''
    rescue => e
      raise "Error: #{e.message}"
    end
  end
end
