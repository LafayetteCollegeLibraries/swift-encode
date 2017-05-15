# coding: utf-8
module SwiftPoemsProject
  class Body < Element

    # Parse the title and headnotes
    def initialize(transcript, content, mode)
      super(transcript,content, mode)

      # Set the identifier
      @transcript.tei.poemElement['n'] = @transcript.poemID

      # @poem = Poem.new(@content, @transcript.poemID, @transcript.workType, @transcript.tei.poemElem, @transcript.footnote_index)

      # Legacy
      # @todo Refactor so that the above becomes valid
      normal_content = SwiftPoemsProject::NotaBene::normalize(@content)
      nota_bene_content = normal_content

      # Replace the ligatures, quotes, and dashes
      NotaBene::NB_ASCII_SEQS.each_pair do |ascii_seq, utf8_seq|
        nota_bene_content = nota_bene_content.gsub(ascii_seq, utf8_seq)
      end

      # XML character entity references must be replaced before being parsed as raw XML
      XML_CHAR_REFS.each_pair do |char_ref, escaped|
        nota_bene_content = nota_bene_content.gsub(char_ref, escaped)
      end

      # Handle the Nota Bene Modecode
      NotaBene::NB_MODECODES.each_pair do |modecode, value|
        # nota_bene_content = nota_bene_content.gsub(/#{modecode}.*(?!«M.{3}»)/, "<hi rend=\"VALUE\">\\1</hi>")
        # nota_bene_content = nota_bene_content.gsub(/#{modecode}(.*)(?!(«M.{3}»))/, "<hi rend=\"VALUE\">\\1")

        closing_mode = value.keys.first
        element_name = value[closing_mode].keys.first
        attrs = []

        value[closing_mode][element_name].each_pair do |attr_name, attr_value|
          attrs << "#{attr_name}=\"#{attr_value}\""
        end

        nota_bene_content = nota_bene_content.gsub(/#{modecode}(.*?)«MDNM»/, "<hi #{attrs.join(' ')}>\\1</hi>")
        nota_bene_content = nota_bene_content.gsub(/#{modecode}/, "<hi #{attrs.join(' ')}>")
      end

      nota_bene_content = nota_bene_content.gsub(/«MDNM»/, "</hi>")
      nota_bene_content = nota_bene_content.gsub(/«FN1(.*?)»/, '<note place="foot">\\1</foot>')

      # lines = ['<lg n="1" type="stanza">']
      # Lines should be structured as a NodeSet
      # lines = Nokogiri::XML::NodeSet.new(@transcript.tei.teiDocument)
      lines = []
      stanza = Nokogiri::XML::Node.new('lg', @transcript.tei.teiDocument)
      stanza['n'] = "1"

      # Create <l> elements by iterating through each Nota Bene line
      # 090-26L2   133  Against Dissenters would repine,
      #
      nota_bene_content.each_line do |line|

        # Attempt to extract the line number
        line_m = line.match(/([0-9a-zA-Z\-]{8})   (\d+)  /)
        if line_m
          poem_id = line_m[1]
          line_number = line_m[2]
          line_text = line.gsub(/([0-9a-zA-Z\-]{8})   (\d+)  /, '')
          line_text = line_text.chomp

          xml_id = "swift-#{poem_id}-line-#{line_number}"
          rend_values = []

          # Remove any modecodes for flush-left and flush-center, and add these as attributes to the <tei:l> element
          if line_text.match(/(.*?)«LD\s?»(.+?)/)
            line_text = line_text.sub(/(.*?)«LD\s?»(.+)</, '\\1<space>\\2</space>')
            line_content_prefix = "<l "
          elsif line_text.match(/^(.*?)«FC»(.+?)«FL»/)
            # line_content_prefix = "<l rend=\"center\" "
            line_content_prefix = "<l "
            rend_values << 'center'

            line_text = line_text.sub(/^(.*?)«FC»(.+)«FL»/, '\\1\\2')
          elsif line_text.match(/^(.*?)«FR»(.+?)«FL»/)
            # line_content_prefix = "<l rend=\"flush-right\" "
            line_content_prefix = "<l "
            rend_values << 'flush-right'

            line_text = line_text.sub(/^(.*?)«FR»(.+)«FL»/, '\\1\\2')
          else
            line_content_prefix = "<l "
          end

          # Remove any modecodes for indentation, and add these as attributes to the <tei:l> element
          if line_text.match(/(\|+)/)
            indent_match = line_text.match(/(\|+)/)
            indent_depth = indent_match[1].count('|')

            # line_content_prefix += "indent(#{indent_depth}) "
            rend_values << "indent(#{indent_depth})"

            # Replace "|" sequence
            if @mode == READING
              line_text = line_text.sub(/\|/, '')
            end
          end

          # Replace all "_" sequences with newlines
          if @mode == READING
            line_text = line_text.sub(/_/, '<lb/>')
          end

          if not rend_values.empty?
            line_content_prefix += "rend=\"#{rend_values.join(' ')}\" "
          end

          # Create the actual XML Element to be appended to the TEI Document
          line_content = line_content_prefix + "xml:id=\"#{xml_id}\" n=\"#{line_number}\">" + line_text + "</l>"
          line_element = Nokogiri::XML.fragment(line_content)

          if line_element.to_xml != line_content

            # When the fragment's first child is a <l>...
            if line_element.children.length > 1

              if line_element.children.first.name == 'l'

                # previous_line_element = line_element = Nokogiri::XML.fragment(lines.last)
                previous_line_element = lines.last
                
                opened_element = previous_line_element.children.last.children.last
                opened_element_raw = opened_element.to_xml.sub(/>.+$/, '>')

                line_content = "<l xml:id=\"#{xml_id}\" n=\"#{line_number}\">" + opened_element_raw + line_text + "</l>"
              end
            end
          end

          # Clean artifacts from the Nota Bene encoding
          line_content = line_content.gsub(/\.{2,}/, '.')
          line_element = Nokogiri::XML.fragment(line_content)

          # Ensure that entity references "&apos;" are replaced by "'" characters
          # Resolves SPP-861
          if /&apos;/.match line_content
            replaced_line_content = line_content.gsub(/&apos;/, "'")
            replaced_line_element = Nokogiri::XML.fragment(replaced_line_content)

            if replaced_line_element.content != line_element.content
              
              line_element = replaced_line_element

            end
          end

          # Line elements are appended to the NodeSet
          lines << line_element
        else
          # raise "Could not extract the line number from #{line}"
          # If the line number cannot be extracted, this is likely the end of the transcript body
        end
      end

      lines.each do |line_element|
        stanza.add_child(line_element)
      end

      # Add the stanza containing the line elements
      @transcript.tei.poemElem.add_child(stanza)
    end
  end
end
