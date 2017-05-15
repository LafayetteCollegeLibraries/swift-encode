
module SwiftPoemsProject
  module Encoder
    class TeiFileEncoder < TeiEncoder

      def initialize(cache_path, options = {})
        @mail_options = options.fetch(:mail, {})
        
        super(cache_path)
      end

      # Mail an error report
      def mail(custom_options)

        options = {
          :from => 'noreply@localhost.localdomain',
          :to => 'recipient@localhost.localdomain',
          :cc => [],
          :subject => 'Swift Poems Project Encoding Report',
          :body => ''
        }.merge(custom_options)

        Mail.deliver do
          from     options[:fetch]
          to       options[:to]
          cc       options[:cc]
          subject  options[:subject]
          body     options[:body]
        end
      end
      
      def encode(source_id, transcript_id)
        poem_file_path = "#{NB_STORE_PATH}/#{source_id}/#{transcript_id}"
        poem = transcript_id[0..3]

        # Create the poem directory
        poem_dir_path = "#{FILE_STORE_PATH}/poems/#{poem}"

        Dir.mkdir( poem_dir_path ) unless File.exists?( poem_dir_path )
        file_path = poem_file_path
        relative_path = transcript_id
        
        $stdout.puts "Encoding #{file_path}..."

        nota_bene = SwiftPoemsProject::NotaBene::Document.new file_path
        begin
          transcript = SwiftPoemsProject::Transcript.new nota_bene
        rescue Exception => ex
          mail body: ex.message
        else
          
          # Create the source directory
          source_dir_path = "#{FILE_STORE_PATH}/sources/#{source_id}"
          source_file_path = "#{source_dir_path}/#{relative_path}.tei.xml"

          if File.exists? source_file_path
            File.delete source_file_path
          end

          # Encode the transcript
          Dir.mkdir( source_dir_path ) unless File.exists?( source_dir_path )
          File.write( source_file_path, transcript.tei.document.to_xml )

          # Create the symlink
          File.symlink( source_file_path, "#{poem_dir_path}/#{relative_path}.tei.xml" ) unless File.exists?( "#{poem_dir_path}/#{relative_path}.tei.xml" )
        end
      end
    end
  end
end
