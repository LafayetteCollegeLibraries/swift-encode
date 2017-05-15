module SwiftPoemsProject
  # For Titles within the Swift Poems Project
  class TitleSet < Element

    attr_reader :sponsor, :elem, :opened_tags, :footnote_index, :document, :poem    

    def initialize(heading, content, element, poem_id, mode, options = {})
      super(heading.transcript, content, mode)

      @element = element

      # Legacy attribute
      @poem = content

      @poem_id = poem_id

      # Legacy attribute
      @id = @poem_id

      @document = @element.document
      @sponsor = @element.at_xpath('tei:fileDesc/tei:titleStmt/tei:sponsor', TEI_NS)
      @opened_tags = []

      @footnote_index = options[:footnote_index] || 1
        
      @titles = [ SwiftPoemsProject::Title.new(self, @id, { :footnote_index => @footnote_index }) ]
    end

    # Syntactic sugar
    # @todo Refactor
    def length
      @titles.length
    end

    # Syntactic sugar
    # @todo Refactor
    def last
      @titles.last
    end

    # This is likely deprecated and should be removed
    def pushTitle
      last_title = @titles.last

      # Add additional tokens
      @sponsor.add_previous_sibling @titles.last.elem

      @footnote_index = @titles.last.footnote_index

      @titles << SwiftPoemsProject::Title.new(self, @id, { :footnote_index => @titles.last.footnote_index })
      @titles.last.has_opened_tag = last_title.has_opened_tag

      if @titles.last.has_opened_tag

        @opened_tags.unshift last_title.current_leaf

        if not last_title.tokens.empty?
          
          @titles.last.current_leaf = @titles.last.elem.add_child Nokogiri::XML::Node.new last_title.tokens.last, @document
        else

          @titles.last.current_leaf = @titles.last.elem.add_child Nokogiri::XML::Node.new last_title.elem.children.last.name, @document
        end
      end
    end

    def push(token)
      # All lines of the title *must* be inserted into a single <title> Element
      @titles.last.push token
    end

    def close(token)

      token = token.sub /\r/, ''
      
      @titles.last.push token
      pushTitle
    end
  end
end
