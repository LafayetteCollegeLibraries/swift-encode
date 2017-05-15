
require_relative 'tei/TeiPoemHeads'
require_relative 'tei/TeiHead'
require_relative 'tei/TeiLinkGroup'
require_relative 'tei/TeiTitle'
require_relative 'tei/TeiPoem'
require_relative 'tei/TeiStanza'
require_relative 'tei/TeiLine'

module SwiftPoemsProject
  module TEI

    # The essential elements of the TEI document
    # This assumes that all poems belong to a single corpus (a safe assumption at this point, but not safe for the duration of the project!)
    # It may become necessary to structure individual 
    
    # The entire document is within the English language
    # http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ST.html#STGAla

    TEI_P5_MANUSCRIPT = <<EOF
<msDesc>
  <additional></additional>
</msDesc>
EOF

    TEI_P5_DOC = <<EOF
<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">
  <teiHeader>
    <fileDesc>
      <titleStmt>
        <sponsor>Lafayette College</sponsor>
        <principal>James Woolley</principal>
      </titleStmt>
      <publicationStmt>
        <p>Distributed by Digital Scholarship Services at Lafayette College</p>
      </publicationStmt>
      <sourceDesc>
        #{TEI_P5_MANUSCRIPT}
      </sourceDesc>
    </fileDesc>

    <encodingDesc>
      <p></p>
    </encodingDesc>

    <profileDesc>
      <langUsage>
        <language ident="en">English</language>
      </langUsage>
    </profileDesc>
  </teiHeader>
  <text>
    <body>
      <div type="book">
        <div></div>
      </div>
    </body>
  </text>
</TEI>
EOF

    # The XML TEI namespace
    TEI_NS = {'tei' => 'http://www.tei-c.org/ns/1.0'}

    class Document

      attr_reader :document, :link_group

      # Legacy attributes
      attr_reader :teiDocument, :headerElement, :textElem, :bookElem, :poemElem, :poemElement

      def initialize()
        @document = Nokogiri::XML(TEI_P5_DOC, &:noblanks)
        # Legacy attribute
        @teiDocument = @document

        # Should resolve issues related to the parsing of certain unicode characters
        @teiDocument.encoding = 'utf-8'

        @textElem = @teiDocument.at_xpath('tei:TEI/tei:text/tei:body', TEI_NS)

        # There are no poems which are isolated from an identified source
        @bookElem = @textElem.at_xpath('tei:div', TEI_NS)

        @workType = POEM

        # To each <div> shall be delegated a transcription file
        # Extract and strip certain metadata values at the document level
        # Extract the document ID
        @poemElem = @bookElem.at_xpath('tei:div', TEI_NS)
        @poemElement = @poemElem

        # Link Group
        @link_group = TeiLinkGroup.new @poemElem

        @headerElement = @teiDocument.at_xpath('tei:TEI/tei:teiHeader', TEI_NS)
      end

      def to_xml
        @teiDocument.to_xml
      end
    end

    class Header
    end

    class Text
    end

    # <tei:body>
    # This contains the logical headnote sets, headnotes, and footnote set
    class Body
    end

    # Logical, a set of <tei:title> Elements
    class TitleSet
    end

    # <tei:title> Elements
    class Title
    end

    # Logical set of <tei:note type="head">
    class HeadnoteSet
    end

    # <tei:note type="head"> Elements
    class Headnote
    end
  end

  # Module for handling SPP-specific formatting
  module SwiftPoemsProjectPoem

    # The Class for the identifier within a given poem/letter
    class ID

      attr_reader :value

      # Create a new poem ID
      def initialize(value)
        raise NotImplementedError.new "Attempted to mint a poem ID using a blank token" if value.empty?
        @value = value
      end
    end

    # Parse the poem ID from a token
    def self.parse_id(token)
      begin

        # Remove the 8 character identifier from the beginning of the line
        # @todo Refactor and remove redundancy here
        poem_id_match = /\s*(\d+)\s+/.match token
        poem_id_match = /([0-9A-Z\!\-]{8})   /.match(token) if not poem_id_match
        poem_id_match = /([0-9A-Z]{8})   /.match(token) if not poem_id_match
        
        if not poem_id_match
          raise NotImplementedError.new "Could not extract the Poem ID from #{token}"
        else
          value = poem_id_match.to_s.strip
          ID.new(value)
        end
        
      rescue Exception => e
        nil
      end
    end

    # Handling SPP-specific formatting at the level of lines
    module Line
      # The Class for a poem line number
      class Number

        attr_reader :value

        # Create a new line number
        def initialize(value)
          raise NotImplementedError.new "Attempted to mint a line number using a blank token" if value.empty?
          @value = value
        end
      end

      # Parse the line number from a token
      def self.parse_number(token)
        
        begin
          line_number_match = /\s*(\d{1,4})\s+/.match token
        
          if not line_number_match
            raise NotImplementedError.new "Could not extract the line number from #{token}"
          else
            value = line_number_match.to_s.strip
            Number.new(value)
          end
        
        rescue Exception => ex

          $stderr.puts ex
          nil
        end
      end
    end
  end
end
