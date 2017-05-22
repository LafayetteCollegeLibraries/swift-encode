# coding: utf-8

module SwiftPoemsProject
    # This models the functionality unique to Swift Poems Project Transcripts (i. e. Nota Bene Documents)
  # All tokenization is to be refactored here
  class Transcript

    attr_reader :tei, :nota_bene, :id

    # Legacy attributes
    attr_reader :poemID, :teiDocument, :documentTokens, :headerElement, :poemElem, :workType
    attr_accessor :headnote_open, :footnote_index, :headnote_opened_index

    # Normalize the Poem ID for character escape sequences
    # Please see SPP-652
    #
    def normalize_id(id)

      normal_id = id
      ID_ESCAPE_CHARS.each_pair do |char, code|
        normal_id = normal_id.gsub(/#{Regexp.escape(char)}/, code)
      end

      return normal_id
    end

    # Legacy functionality
    # @todo Refactor
    def parse_id

      # Extract the poem ID
      m = /(.?\d\d\d\-?[0-9A-Z\!\-#\$]{4,5})   /.match(@nota_bene.content)

      # Searching for alternate patterns
      # Y46B45L5
      # Y09C27L3
      m = /([0-9A-Z\!\-#\$]{8})   /.match(@nota_bene.content) if not m

      # «MDBO»Filename:«MDNM» 920-0201
      m = /«MDBO»Filename:«MDNM» ([0-9A-Z\!\-]{7,8}[#\$@]?)/.match(@nota_bene.content) if not m
      m = /«MDBO»Filename:«MDNM» ([0-9A-Z\!\-#\$%]{7,8}[#\$@]?)/.match(@nota_bene.content) if not m

      if not m
        raise NoteBeneFormatException.new "#{@filePath} features an ID of an unsupported format" unless m
      else
        id = m[1]
        normalize_id(id)
      end
    end

    def initialize(nota_bene, mode)

      @nota_bene = nota_bene
      @tei = TEI::Document.new
      nota_bene_content = @nota_bene.content
      nota_bene_content = nota_bene_content.gsub(/·/, '')

      lines = nota_bene_content.split(/\$\$\r\n--\r\n\S{8}?\s{3}/)

      # Handle anomalies for the header delimiter
      if lines.length != 2
        lines = nota_bene_content.split(/\$\$\s*\r?\n\S{8}?\s{3}/)
      end

      # Parsing the header
      # @todo Refactor the exception if a header, body, and footer isn't present
      if lines.length != 2
        raise NotImplementedError.new "Could not parse the structure of the Nota Bene transcript #{@nota_bene.file_path}: doesn't have a header"
      end

      @header = Header.new self, lines.shift, mode

      lines = lines.last.split(/##\s*\r?\n/)

      # Parsing the heading
      # @todo Refactor the exception
      if lines.length != 2
        raise NotImplementedError.new "Could not parse the structure of the Nota Bene transcript #{@nota_bene.file_path}: doesn't have a heading"
      end

      # Legacy attributes for the state of the transcript
      # @todo Refactor
      @headnote_open = false
      @footnote_index = 0
      @teiDocument = @tei.teiDocument
      @documentTokens = []
      @headerElement = @tei.headerElement
      @poemElem = @tei.poemElem
      # @termToken = nil
      # @poem = @body.poem

      # Initialize the legacy attributes
      @id = parse_id
      @poemID = @id

      # This deprecates "titleAndHeadnote"
      @heading = Heading.new self, lines.shift, mode
      if @heading.content.match(/letter/i)
        @workType = LETTER
      else
        # By default, all documents are poems
        @workType = POEM
      end

      # Parsing the body and footer
      lines = lines.last.split(/%%\r?\n?/)
      # @todo Refactor the exception
      if lines.length < 2
        raise NotImplementedError.new "Could not parse the structure of the Nota Bene transcript #{@nota_bene.file_path}: doesn't have a body and footer"
      end

      @body = Body.new self, lines.shift, mode
      @footer = Footer.new self, lines.pop, mode
    end
  end
end
