# lib/processor.rb

module CSVExtension
  class Processor
    def self.process_data(data, input_folder, input_filename)
      cortes = data.select { |row| row['Tipo'] == 'Tablero' }
      materiales = {}

      # Initialize cortes output with headers
      cortes_output = []
      cortes_output << ['COLOR DE PLACA Y MATERIAL', 'CANTIDAD', 'LARGO', 'CORTO', 'DETALLE', 'Veta', 'L*', 'L*', 'C*', 'C*']

      cortes.each do |row|
        longitud = Converter.clean_and_convert(row['Longitud - cruda'])
        canto_longitud_1 = Converter.canto_value(row['Longitud del borde 1'])
        canto_longitud_2 = Converter.canto_value(row['Longitud del borde 2'])
    
        anchura = Converter.clean_and_convert(row['Ancho - crudo'])
        canto_anchura_1 = Converter.canto_value(row['Ancho del borde 1'])
        canto_anchura_2 = Converter.canto_value(row['Ancho de borde 2'])

        if anchura > longitud
          largo, corto = anchura, longitud
          canto_largo_1, canto_largo_2 = canto_anchura_1, canto_anchura_2
          canto_corto_1, canto_corto_2 = canto_longitud_1, canto_longitud_2
        else
          largo, corto = longitud, anchura
          canto_largo_1, canto_largo_2 = canto_longitud_1, canto_longitud_2
          canto_corto_1, canto_corto_2 = canto_anchura_1, canto_anchura_2
        end

        detalle = row['Designación'].to_s.split[0..1].join(' ')

        # Add each row as an array
        cortes_output << [
          row['Material'],
          row['Cantidad'],
          largo.round,
          corto.round,
          detalle,
          '',
          canto_largo_1,
          canto_largo_2,
          canto_corto_1,
          canto_corto_2
        ]
      end

      # Export cortes
      Exporter.export_csv("#{input_filename}_cortes.csv", cortes_output, input_folder)
      
      # Process materiales
      materiales = {}
      data.each do |row|
        tipo = row['Tipo']
        material = row['Material']
        next if material == 'SinCanto'

        case tipo
        when 'Tablero'
          area = Converter.clean_and_convert(row['Area - final'])
          materiales[material] ||= 0
          materiales[material] += area
        when 'Canto'
          longitud = Converter.clean_and_convert(row['Longitud'])
          materiales[material] ||= 0
          materiales[material] += longitud / 1000 
        when 'Accesorio'
          cantidad = Converter.clean_and_convert(row['Cantidad'])
          materiales[material] ||= 0
          materiales[material] += cantidad
        end
      end

      # Export materiales
      Exporter.export_csv("#{input_filename}_materiales.csv", materiales, input_folder)
    rescue => e
      raise "Error: #{e.message}"
    end
  end
end
