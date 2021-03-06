
module SwiftPoemsProject
  module Encoder
    class TeiEncoder
      
      def initialize(cache_path)
        @cache_path = cache_path
      end
      
      def _encode(transcript_id, nota_bene_content)
        nota_bene = SwiftPoemsProject::NotaBene::Document.new(content: nota_bene_content)
        transcript = SwiftPoemsProject::Transcript.new(nota_bene, 'reading')

        begin
          transcript = SwiftPoemsProject::Transcript.new(nota_bene, 'reading')
        rescue Exception => e
          NotImplementedError.new("The following failures were encountered when attempting to encode #{transcript_id}: #{e.message}.")
        end
        
        return transcript
      end
      
      def encode(transcript_id, nota_bene_content, nota_bene_mtime)
        
        cached_file_path = File.join(@cache_path, transcript_id + '.tei.xml')
        
        if File.exist? cached_file_path
          cached_mtime = File.mtime(cached_file_path)
          
          # Convert to a DateTime
          cached_mtime = DateTime.parse(cached_mtime.to_s)
          
          if !nota_bene_mtime.nil? && nota_bene_mtime <= cached_mtime
            result = File.read(cached_file_path)
          else
            transcript = _encode(transcript_id, nota_bene_content)
            
            File.open(cached_file_path, 'wb') {|f| f.write(transcript.tei.document.to_xml) }
            result = transcript.tei.document.to_xml
          end
        else
          transcript = _encode(transcript_id, nota_bene_content)
          File.open(cached_file_path, 'wb') {|f| f.write(transcript.tei.document.to_xml) }
          result = transcript.tei.document.to_xml
        end
        
        return result
      end
    end
  end
end
