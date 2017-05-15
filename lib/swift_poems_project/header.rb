# coding: utf-8

module SwiftPoemsProject
  # Class for modeling the "headers" within SPP Transcripts
  # (These are blocks of text which contain SPP Transcript metadata, formatted in a manner which is unique to the project)
  class Header < Element

    def initialize(transcript, content, mode)
      super(transcript,content, mode)

      @content.each_line do |line|
        
        line.chomp!

        if /Other editing\:/.match(line)
          other_editing_m = /Other editing\:\s?«MDNM»(.+)/.match(line)
          other_editing_m = /Other editing\:\s?(.+)/.match(line) unless other_editing_m

          @transcript.tei.headerElement.at_xpath('tei:encodingDesc/tei:p', TEI_NS).content = other_editing_m[1]
        end

        if /& dates?:/.match(line)
          
          # Extracting the <name> values from the parse "Transcriber & date" value
          if /Transcriber & date:/.match(line)
            
            respStmtElem = Nokogiri::XML::Node.new('respStmt', @transcript.tei.teiDocument)
            nameElem = Nokogiri::XML::Node.new('name', @transcript.tei.teiDocument)
            
            transcriber_m = /Transcriber & date:.?«MDNM.?»\s?(.+)\s?/.match(line)
            
            if transcriber_m
              name = transcriber_m[1]
              nameElem['key'] = name
              respStmtElem.add_child(nameElem)
            else
              raise NotImplementedError.new "Failed to extract the transcribers from #{line}"
            end
            
            respElem = Nokogiri::XML::Node.new('resp', @transcript.tei.teiDocument)
            respElem.content = 'transcription'
            respStmtElem.add_child(respElem)
            
            @transcript.tei.headerElement.at_xpath('tei:fileDesc/tei:titleStmt', TEI_NS).add_child(respStmtElem)

          elsif /Proofed by & dates?:/.match(line)
            
            respStmtElem = Nokogiri::XML::Node.new('respStmt', @transcript.tei.teiDocument)
            
            nameElem = Nokogiri::XML::Node.new('name', @transcript.tei.teiDocument)
            
            # This handles lines formatted in the following manner:
            # Proofed by & dates:«MDNM» √'d JW 20JE07 agt 07H1; TNiese 25JA11
            # Note that there may be more than one name
            names = /Proofed by & dates:.?«MDNM.?» (.+)/
              .match( "Proofed by & dates:«MDNM» √'d JW 20JE07 agt 07H1; TNiese 25JA11" )[1]
              .sub(/√'d /, '')
              .split(';')
              .each { |s| s.strip! }
            
            names.each do |name|
              
              nameElem['key'] = name
              
              respElem = Nokogiri::XML::Node.new('resp', @transcript.tei.teiDocument)
              respElem.content = 'proof corrected'
              
              respStmtElem.add_child(respElem)
              respStmtElem.add_child(nameElem)
            end
            
            @transcript.tei.headerElement.at_xpath('tei:fileDesc/tei:titleStmt', TEI_NS).add_child(respStmtElem)
          elsif /Scanned by & date\:/.match(line)
            
            # This handles lines formatted in the following manner:
            # «MDBO»Scanned by & date:«MDNM» AGendler 22JE04
            respStmtElem = Nokogiri::XML::Node.new('respStmt', @transcript.tei.teiDocument)
            
            nameElem = Nokogiri::XML::Node.new('name', @transcript.tei.teiDocument)
            
            scanner_m = /Scanned by & date:«MDNM» (.+)/.match(line)
            
            if scanner_m
              
              name = scanner_m[1]
              nameElem['key'] = name
              respStmtElem.add_child(nameElem)
            end
            
            respElem = Nokogiri::XML::Node.new('resp', @transcript.tei.teiDocument)
            respElem.content = 'scanning'
            respStmtElem.add_child(respElem)
          elsif /File prepared by & date\:/.match(line)

            # This handles lines formatted in the following manner:
            # «MDBO»File prepared by & date:«MDNM» AGendler 22JE04
            respStmtElem = Nokogiri::XML::Node.new('respStmt', @transcript.tei.teiDocument)
            
            nameElem = Nokogiri::XML::Node.new('name', @transcript.tei.teiDocument)
            
            file_prepared_m = /File prepared by & date:«MDNM» (.+)/.match(line)
            
            if file_prepared_m
              
              name = file_prepared_m[1]
              nameElem['key'] = name
              respStmtElem.add_child(nameElem)
            end
            
            respElem = Nokogiri::XML::Node.new('resp', @transcript.tei.teiDocument)
            respElem.content = 'File prepared by'
            respStmtElem.add_child(respElem)          
          else            
            raise NotImplementedError, "Failed to parse the header value #{line}"
          end
        end
      end
    end
  end
end
