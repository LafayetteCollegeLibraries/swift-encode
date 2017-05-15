
module SwiftPoemsProject
  class Element
    
    attr_reader :content, :transcript

    def initialize(transcript, content, mode)
      @transcript = transcript
      @content = content
      @mode = mode
    end
  end
end
