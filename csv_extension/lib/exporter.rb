# lib/exporter.rb

module CSVExtension
  class Exporter
    def self.export_csv(filename, data, input_folder)
      return if data.empty?
      
      # Ensure the input folder path is properly formatted
      input_folder = File.expand_path(input_folder)
      file_path = File.join(input_folder, filename)
      
      # Ensure the directory exists
      FileUtils.mkdir_p(File.dirname(file_path))
      
      # Write with UTF-8 encoding and handle line endings
      CSV.open(file_path, "w:UTF-8", row_sep: "\r\n", col_sep: ";", force_quotes: true) do |csv|
        # Add UTF-8 BOM for Excel compatibility
        csv << ["\uFEFF"]
        data.each do |row|
          # Format numeric values with decimal separator
          formatted_row = row.map do |value|
            if value.is_a?(Numeric)
              # Use comma as decimal separator for better Excel compatibility
              value.to_s.gsub('.', ',')
            else
              value
            end
          end
          csv << formatted_row
        end
      end

    rescue => e
      raise "Error: #{e.message}"
    end
  end
end
