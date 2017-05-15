
module SwiftPoemsProject
  module GDrive
    class NotaBeneStore

      def self.excluded?(file, source_id = nil)
        if EXCLUDED_TRANSCRIPTS.include?(file.name)
          raise Exception.new "File #{file.name} is excluded"
        elsif source_id && EXCLUDED_SOURCES.include?(source_id)
          raise Exception.new "Source #{source_id} is excluded"
        elsif EXCLUDED_SUFFIXES.map { |suffix| !!/#{Regexp.escape(suffix)}$/.match(file.name) }.reduce(:|)
          raise Exception.new "File #{file.name} is excluded by suffix"
        elsif EXCLUDED_PREFIXES.map { |prefix| !!/^#{Regexp.escape(prefix)}.*/.match(file.name) }.reduce(:|)
          raise Exception.new "File #{file.name} is excluded by prefix"
        elsif file.size < MIN_FILE_SIZE
          raise Exception.new "File #{file.name} is excluded by size"
        end
      end

      def initialize(client_secrets_path, scope, app_name, cache_path)
        @service = Service.new(client_secrets_path, scope, app_name)
        @cache_path = cache_path
      end

      # Retrieve either a cached copy or directly download a Nota Bene file from Google Drive
      #
      def get(file, source_id = nil)
        NotaBeneStore.excluded?(file, source_id)
        
        results = {}
        
        gdrive_mtime = file.modified_time
        cached_file_path = File.join(@cache_path, file.name)
        
        results[:id] = file.name
        results[:mtime] = gdrive_mtime
        
        if File.exists? cached_file_path
          cached_mtime = File.mtime(cached_file_path)
          # Convert this into a DateTime Object
          cached_mtime = DateTime.parse(cached_mtime.to_s)
          
          if File.exist? cached_file_path
            if gdrive_mtime <= cached_mtime

              results[:mtime] = cached_mtime
              results[:content] = File.read(cached_file_path)
            else
              results[:content] = @service.file(file.id, file.name, cached_file_path)
            end
            
          else
            results[:content] = @service.file(file.id, file.name, cached_file_path)
          end
        else
          results[:content] = @service.file(file.id, file.name, cached_file_path)
        end

        return results
      end

      # Retrieve a Nota Bene file for a given transcript ID
      def transcript(transcript_id, source_id)
        files = @service.files("name = '#{transcript_id}'")
        raise Exception.new "Failed to find the file for #{transcript_id}" if files.empty?
        get(files.last, source_id)
      end

      def poems()
        files = @service.files()

        files.reject { |file| @excluded_files.include? file.name }.map do |file|
          get(file)
        end
      end
      
      def get_cached_transcripts(poem_id: nil)
        cached_file_paths = Dir.glob(File.join(@cache_path, "#{poem_id}*"))
        return cached_file_paths.map { |cached_file_path| {id: File.basename(cached_file_path)} }
      end

      def transcripts(poem_id: nil)

        cached_transcripts = get_cached_transcripts(poem_id: poem_id)
        return cached_transcripts unless cached_transcripts.empty?

        files = @service.files("name contains '#{poem_id}*'")

        filtered_files = []

        files.each do |file|
          if !@excluded_files.include?(file.name) && file.name != poem_id && /^#{Regexp.escape(poem_id)}/.match(file.name)
            filtered_files << file
          end
        end
        
        filtered_files.map do |file|
          get(file)
        end
      end
    end
  end
end
