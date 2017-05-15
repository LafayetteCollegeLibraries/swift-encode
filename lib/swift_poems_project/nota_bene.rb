# coding: utf-8

require 'csv'
require_relative 'nota_bene/NotaBeneDelta'
require_relative 'nota_bene/NotaBeneHeadnoteParser'
require_relative 'nota_bene/NotaBeneTitleParser'

require_relative 'nota_bene/constants'

module SwiftPoemsProject
  module NotaBene

    def NotaBene.normalize(poem)
        
      # poem = NotaBeneNormalizer::normalize poem
      
      NB_BLOCK_LITERAL_PATTERNS.each do |pattern|

        poem = poem.sub pattern, '«UNCLEAR»'
      end
      
      return poem
    end

    def NotaBene.convert_modecodes(content)
      EXTENDED_MODECODES.each_pair do |modecode, translated|
        content = content.gsub(modecode, translated)
      end

      content
    end

    def NotaBene.convert_breves(content)
      content.gsub(/([A-Za-z])ª/, "\\1\u0306")
    end

    def NotaBene.convert_macrons(content)
      content.gsub(/([A-Za-z])ⁿ/, "\\1\u0304")
    end

    class Document

    attr_reader :content, :tokens, :file_path

    # Constructor
    #
    #
    def initialize(options)
      file_path = options.fetch(:file_path, nil)
      content = options.fetch(:content, nil)
      cleaning_file_path = options.fetch(:cleaning_file_path, nil)
      
      if content.nil?
        @file_path = file_path
        
        # Legacy attribute
        @filePath = @file_path
        
        # Read the file and convert the CP437 encoding into UTF-8
        @content = File.read(@filePath, :encoding => 'cp437:utf-8')
      else
        @content = content
      end
      
      @content = NotaBene::convert_modecodes(@content)
      @content = NotaBene::convert_macrons(@content)
      @content = NotaBene::convert_breves(@content)
      
      # The tokens should be related to a single document
      @tokens = []
      @termToken = nil
      
      clean cleaning_file_path
    end
    
    def tokenize
      # This splits for each Nota Bene mode code
      @tokens = @content.split /(?=«)|(?=[\.─\\a-z]»)|(?<=«FN1·)|(?<=»)|(?=om\.)|(?<=om\.)|(?=\\)|(?<=\\)|(?=_)|(?<=_)|(?=\|)|(?<=\|)|\n/
    end
    
    def tokenize_titles(content)
      content.split /(?=«)|(?=\.»)|(?<=«FN1·)|(?<=»)|(?=\s\|)|(?<=\s\|)|(?=_\|)|(?<=_\|)/
    end
    
    def clean(csv_file_path)
      if csv_file_path
        ::CSV.foreach(csv_file_path, headers: :first_row, return_headers: false) do |row|
          
          # Replace each row
          line_pattern = row[2]
          replacement = row[3]
          
          @content = @content.gsub(/#{Regexp.escape(line_pattern)}/, replacement)
        end
      end
    end
  end
  end
end
