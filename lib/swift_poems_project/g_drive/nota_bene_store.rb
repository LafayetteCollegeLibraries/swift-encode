
module SwiftPoemsProject
  module GDrive
    class NotaBeneStore

      def self.excluded?(file, source_id = nil)
        if EXCLUDED_TRANSCRIPTS.include?(file.name)
          raise StandardError.new "File #{file.name} is excluded"
        elsif source_id && EXCLUDED_SOURCES.include?(source_id)
          raise StandardError.new "Source #{source_id} is excluded"
        elsif EXCLUDED_SUFFIXES.map { |suffix| !!/#{Regexp.escape(suffix)}$/.match(file.name) }.reduce(:|)
          raise StandardError.new "File #{file.name} is excluded by suffix"
        elsif EXCLUDED_PREFIXES.map { |prefix| !!/^#{Regexp.escape(prefix)}.*/.match(file.name) }.reduce(:|)
          raise StandardError.new "File #{file.name} is excluded by prefix"
        elsif file.size < MIN_FILE_SIZE
          raise StandardError.new "File #{file.name} is excluded by size"
        end
      end

      def initialize(client_secrets_path, scope, app_name, cache_path, poems_config_path)
        @service = Service.new(client_secrets_path, scope, app_name)
        @cache_path = cache_path
        @poems_config_path = poems_config_path
        @poems_list = YAML.load_file(poems_config_path)
      end


      # Retrieve either a cached copy or directly download a Nota Bene file from Google Drive
      #
      def get(file, source_id = nil)
        
        results = {}
        begin
          NotaBeneStore.excluded?(file, source_id)
        rescue
          return results
        end
        
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
      def transcript(transcript_id, source_id = nil)
        files = @service.files("name = '#{transcript_id}'")
        raise Exception.new "Failed to find the file for #{transcript_id}" if files.empty?
        get(files.last, source_id)
      end

      def poem_codes
        @poems_list.map { |poem_code| { 'id': poem_code } }
      end

      def seed_poem_codes
        poem_codes = @service.files("mimeType != 'application/vnd.google-apps.folder'").select { |file| file.name.length == 8 }.map do |file|

          begin
            NotaBeneStore.excluded?(file, nil)
          rescue
            next
          end

          file.name[0,4]
        end.uniq

        File.open(@poems_config_path, 'wb') { |f| f.write(YAML.dump(poem_codes)) }
        @poems_list = YAML.load_file(@poems_config_path)
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
          if file.name != poem_id && /^#{Regexp.escape(poem_id)}/.match(file.name)
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
