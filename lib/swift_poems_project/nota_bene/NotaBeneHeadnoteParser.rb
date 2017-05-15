# -*- coding: utf-8 -*-

require_relative 'NotaBeneHeadFieldParser'

module SwiftPoemsProject

  class NotaBeneHeadnoteParser < NotaBeneHeadFieldParser

    attr_accessor :footnote_index

    def initialize(teiParser, id, text, docTokens = nil, cleanModeCodes = true, options = {})

      super(teiParser, id, text, docTokens, options)

      # Note: This assumes that HN fields consistently begin with an index of 1 and increment solely by a value of 1
      @heads = TeiPoemHeads.new @transcript, @teiParser.poemElem, @id, '1', { :footnote_index => @footnote_index }
      @cleanModeCodes = cleanModeCodes
    end

    # Refactor
    def parse(line)

      # Handling for the decorator patterns
      line = line.gsub /«MD[SUNMD]{2}»\*(«MDNM»)?/, ''

      line = line.gsub /──»/, '──.»'

      # Resolves issues related to certain footnote terminating modecodes
      # See SPP-93
      line = line.gsub /([a-z\.]\d+?)»/, '\\1.»'
      line = line.gsub /([a-z\\])»/, '\\1.»'

      # This resolves SPP-559
      line = line.gsub(/«FN1·«MDNM»/, '«MDNM»«FN1·')

      # Parse for the HN index
      m = /HN(\d\d?) ?(.*)/.match(line)
      if not m

        # If this is not present, check with the TEI document in order to determine whether or not a HN was previously opened
        if @teiParser.headnote_open

          headIndex = @teiParser.headnote_opened_index
          headContent = line
        else

          raise NotImplementedError.new "Failed to parse the following line as a headnote: #{line}"
        end
      else

        # headIndex = m[1]

        # Update the index of the currently opened HN
        @teiParser.headnote_opened_index = m[1]
        headIndex = @teiParser.headnote_opened_index

        headContent = m[2]

        # @todo Refactor
        # @heads.pushHead if @teiParser.headnote_opened_index.to_i > 1
        if @teiParser.headnote_opened_index.to_i > 1

          @heads.pushHead
        end
      end

      # This needs to be refactored for tokens which encoded content beyond that of 1 line
      if headContent != ''

        # Push the tokenized NB content of each HN line to the set of HN's
        initialTokens = headContent.split /(?=«)|(?=\.»)|(?<=«FN1·)|(?<=»)|\s(?=om\.)|(?<=om\.)|(?=\|)|(?<=\|)|(?=_)|(?<=_)|\n/

        initialTokens.each do |initialToken|

          # poem.push initialToken
          @heads.push initialToken
        end
      end
    end
  end
end
