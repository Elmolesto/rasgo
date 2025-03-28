# sketchup/importer.rb

module CSVExtension
  class Importer
    def self.import_csv
      file_path = UI.openpanel("Select CSV File", "", "CSV Files|*.csv||")
      return unless file_path

      input_folder = File.dirname(file_path)
      input_filename = File.basename(file_path)
      data = CSV.read(file_path, headers: true)

      begin
        Processor.process_data(data, input_folder, input_filename)
        UI.messagebox("Exportado con éxito")
      rescue => e
        UI.messagebox("Error: #{e.message}")
      end
    end
  end
end
