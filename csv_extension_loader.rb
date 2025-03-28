require 'sketchup.rb'
require 'extensions'

module CSVExtension
  PLUGIN_DIR = File.dirname(__FILE__) + "/csv_extension"
  PLUGIN_FILE = PLUGIN_DIR + "/main.rb"

  unless file_loaded?(__FILE__)
    ex = SketchupExtension.new("Rasgo CSV", "csv_extension/main")
    ex.description = "Imports a CSV file and exports two processed CSVs."
    ex.version = "0.0.2"
    ex.creator = "Rasgo"
    
    Sketchup.register_extension(ex, true)
    file_loaded(__FILE__)
  end

  # Método para recargar el plugin automáticamente cuando el archivo cambia
  def self.watch_file
    Thread.new do
      last_mtime = File.mtime(PLUGIN_FILE)
      loop do
        sleep 2  # Revisa cada 2 segundos
        new_mtime = File.mtime(PLUGIN_FILE) rescue last_mtime
        if new_mtime > last_mtime
          last_mtime = new_mtime
          puts "🔄 Recargando CSVExtension..."
          load PLUGIN_FILE
        end
      end
    end
  end

  watch_file
end
