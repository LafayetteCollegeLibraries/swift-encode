require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

module SwiftPoemsProject
  module GDrive
    
    class Service
      def initialize(client_secrets_path, scope, app_name)

        client_secrets_file = File.open(client_secrets_path, 'rb')
        @credentials = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: client_secrets_file, scope: scope)

        @service= Google::Apis::DriveV3::DriveService.new
        @service.client_options.application_name = app_name
        @service.authorization = @credentials
      end

      def files(query = nil, fields = "nextPageToken, files(id, name, modifiedTime, size)")
        page_token = nil
        files = []

        begin
          if query.nil?
            response = @service.list_files(fields: fields, page_token: page_token)
          else
            response = @service.list_files(q: query, fields: fields, page_token: page_token)
          end

          files += response.files
          page_token = response.next_page_token
        end while !page_token.nil?

        files
      end

      def file(file_id, file_name, dest_path)
        begin
          @service.get_file(file_id, download_dest: dest_path)
          File.read(dest_path)
        rescue => e
          $stderr.puts e.message
          nil
        end
      end
    end
  end
end
