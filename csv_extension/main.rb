require 'csv'

# Require Ruby classes from the 'lib' folder
require_relative 'lib/converter'
require_relative 'lib/processor'
require_relative 'lib/exporter'

# Require SketchUp-specific classes from the 'sketchup' folder
require_relative 'ui/importer'

module CSVExtension
  if !file_loaded?(__FILE__)
    menu = UI.menu("Plugins").add_submenu("Rasgo")
    menu.add_item("Procesar OCL CSV") { Importer.import_csv }
    file_loaded(__FILE__)
  end
end
