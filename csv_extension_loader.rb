require 'sketchup.rb'
require 'extensions'
require 'net/http'
require 'json'

module CSVExtension
  PLUGIN_DIR = File.dirname(__FILE__) + "/csv_extension"
  PLUGIN_FILE = PLUGIN_DIR + "/main.rb"
  CURRENT_VERSION = "0.0.5"
  GITHUB_API_URL = "https://api.github.com/repos/Elmolesto/rasgo/releases/latest"

  def self.check_for_updates
    begin
      uri = URI(GITHUB_API_URL)
      response = Net::HTTP.get(uri)
      latest_release = JSON.parse(response)
      latest_version = latest_release['tag_name'].delete('v')
      
      # Compare versions (simple string comparison works for semantic versioning)
      if latest_version > CURRENT_VERSION
        msg = "A new version (#{latest_version}) of Rasgo CSV is available!\n\n" +
              "Current version: #{CURRENT_VERSION}\n" +
              "Latest version: #{latest_version}\n\n" +
              "Please visit the releases page to download the update:\n" +
              "https://github.com/Elmolesto/rasgo/releases"
        
        UI.messagebox(msg)
      end
    rescue => e
      puts "Error checking for updates: #{e.message}"
    end
  end

  unless file_loaded?(__FILE__)
    ex = SketchupExtension.new("Rasgo CSV", "csv_extension/main")
    ex.description = "Imports a CSV file and exports two processed CSVs."
    ex.version = CURRENT_VERSION
    ex.creator = "Rasgo"
    
    Sketchup.register_extension(ex, true)
    file_loaded(__FILE__)
    
    # Check for updates when the plugin loads
    check_for_updates
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
