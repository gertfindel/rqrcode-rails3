module RQRCode
  module Renderers
    class SVG
      class << self
        # Render the SVG from the qrcode string provided from the RQRCode gem
        #   Options:
        #   offset - Padding around the QR Code (e.g. 10)
        #   unit   - How many pixels per module (Default: 11)
        #   fill   - Background color (e.g "ffffff" or :white)
        #   color  - Foreground color for the code (e.g. "000000" or :black)

        def render(qrcode, options={})
          offset  = options[:offset].to_i || 0
          color   = options[:color]       || "000"
          unit    = options[:unit]        || 11
          text    = options[:text]        || ""

          # height and width dependent on offset and QR complexity
          dimension = (qrcode.module_count*unit) + (2*offset)
          width     = dimension
          height    = dimension 
          height    += 6*unit if text.present?


          xml_tag   = %{<?xml version="1.0" standalone="yes"?>}
          open_tag  = %{<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ev="http://www.w3.org/2001/xml-events" width="#{width}" height="#{height}">}
          close_tag = "</svg>"

          result = []
          x = y = c =0
          qrcode.modules.each_index do |c|
            tmp = []
            qrcode.modules.each_index do |r|
              y = c*unit + offset
              x = r*unit + offset

              next unless qrcode.is_dark(c, r)
              tmp << %{<rect width="#{unit}" height="#{unit}" x="#{x}" y="#{y}" style="fill:##{color}"/>}
            end 
            result << tmp.join
          end
          result << %{<text x="0" y="#{height-unit}" font-family="arial" font-size="#{5*unit}"><tspan style="font-weight:bold">#{text}</tspan></text>} if text.present?

          
          if options[:fill]
            result.unshift %{<rect width="#{width}" height="#{height}" x="0" y="0" style="fill:##{options[:fill]}"/>}
          end
          
          svg = [xml_tag, open_tag, result, close_tag].flatten.join("\n")
        end
      end
    end
  end
end
