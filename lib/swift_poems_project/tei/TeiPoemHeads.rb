# -*- coding: utf-8 -*-

module SwiftPoemsProject

  class TeiPoemHeads

    attr_reader :elem, :id, :transcript

    # Legacy attributes
    attr_reader :parser
    attr_accessor :opened_tags

    def initialize(transcript, elem, id, index, options = {})

      @transcript = transcript

      # Legacy attributes
      @parser = @transcript

      @elem = elem
      @id = id
      @document = elem.document
      @opened_tags = []

      @footnote_index = options[:footnote_index] || 0
      
      @heads = [ TeiHead.new(@document, self, index, { :footnote_index => @footnote_index }) ]
    end
    
    def pushHead

      last_head = @heads.last

      @heads << TeiHead.new(@document, self, @heads.last.elem['n'].to_i + 1, { :footnote_index => @heads.last.footnote_index })
      @heads.last.has_opened_tag = last_head.has_opened_tag

      # @todo Refactor with pushTitle
      if @heads.last.has_opened_tag

        @opened_tags.unshift last_head.current_leaf
        @heads.last.current_leaf = @heads.last.elem.add_child Nokogiri::XML::Node.new last_head.elem.children.last.name, @document
      end
    end

    def push(token)

      if @heads.length == 1 and @heads.last.elem.content.empty?
        @heads.last.push token
      else
        # Trigger a new line
        token = token.sub /\r/, ''
        @heads.last.push token
      end
    end

    def close(token)

      token = token.sub /\r/, ''
      @heads.last.push token
      pushHead
      
      @heads.map { |title| title.elem }
    end
  end
end
