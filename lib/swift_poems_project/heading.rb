# coding: utf-8
module SwiftPoemsProject

    class Heading < Element

    # Legacy attributes
    attr_reader :teiDocument, :documentTokens, :headerElement

    # Parse the title and headnotes
    def initialize(transcript, content, mode)
      super(transcript, content, mode)

      # Legacy attributes
      @teiDocument = @transcript.teiDocument
      @documentTokens = @transcript.documentTokens
      @headerElement = @transcript.headerElement

      # Handle imbalanced modecodes
      @content = @content.gsub(/«MDRV»(.)«MDUL»/, '«MDRV»\\1«MDNM»«MDUL»')

      # Single parser instance must be utilized for multiple lines
      # @todo Refactor and restructure the parsing process
      headnote_parser = NotaBeneHeadnoteParser.new @transcript, @transcript.poemID, @content, nil, { :footnote_index => @transcript.footnote_index }

      # For each line containing the title and head-note fields...

      # Split the content on the first occurrence of the sequence "HN1"

      lines = @content.split(/.(?=HN1)/)
      if lines.length != 2
        
        # Handling for cases in which the headnotes aren't delimited using the "HN" sequence
        # Please see SPP-606
        lines = [ @content.split(/\n/)[0], @content.split(/\n/)[1..-1].join("\n") ]
      end

      title_content = lines.shift
      headnotes_content = lines.shift

      titles = TitleSet.new(self, @content, @transcript.headerElement, @transcript.poemID, mode, { :footnote_index => @transcript.footnote_index })
      title_content.each_line do |line|        

        line.chomp!

        # ...remove the poem ID
        # @todo This should be refactored into <tei:title>
        line = line.sub(POEM_ID_PATTERN, '')

        line.strip!
        
        # ...continue to the next line if the line is empty or simply consists of the string "--"
        if line == '' or line == '--'
          next
        end

        tokens = @transcript.nota_bene.tokenize_titles(line)

        # As there exists no actual terminating character for titles, the index within the array must be used in order to generate the note
        tokens[0..-2].each do |token|
          titles.push token
        end

        titles.close tokens.last

        @transcript.footnote_index = titles.footnote_index
      end

      # Omit lines containing HN and -- for Headnote values
      # (These values do not map to any Element within a given TEI schema

      headnotes_content.each_line do |line|

        # ...remove the poem ID
        # @todo This should be refactored into <tei:title>
        line = line.sub(POEM_ID_PATTERN, '')
        
        headnote_parser.footnote_index = @transcript.footnote_index
          
        # Work-around
        # @todo Refactor
        @transcript.headnote_open = true

        # Remove the backspaces
        line = line.gsub(/ 08\./, '')

        headnote_parser.parse line
        @transcript.footnote_index = headnote_parser.footnote_index
      end
    end
  end
end
