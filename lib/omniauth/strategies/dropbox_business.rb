require "omniauth/strategies/oauth2"
require "net/http"
require "uri"
require "json"

module OmniAuth
  module Strategies
    class DropboxBusiness < OmniAuth::Strategies::OAuth2
      option :name, "dropbox_business"
      option :client_options, {
        site: "https://api.dropbox.com",
        authorize_url: "https://www.dropbox.com/oauth2/authorize",
        token_url: "https://api.dropbox.com/oauth2/token"
      }

      uid { raw_info["team_id"] }

      info do
        {
          "uid" => raw_info["team_id"],
          "name" => raw_info["profile"]["name"]["display_name"],
          "email" => raw_info["profile"]["email"]
        }
      end


      extra do
        {"raw_info" => raw_info}
      end

      def authorize_params
        super.tap do |params|
          params[:token_access_type] = "offline"
        end
      end


      def raw_info
        email = request.params['dropbox_business_admin_email'] || session['dropbox_business_admin_email']

        members_uri = URI.parse("https://api.dropboxapi.com/2/team/members/get_info_v2")
        members_request = Net::HTTP::Post.new(members_uri)
        members_request.content_type = "application/json"
        members_request["Authorization"] = "Bearer #{access_token.token}"
        members_request.body = JSON.dump({
          members: [
            {
              ".tag": "email",
              email: email
            }
          ]
        })

        members_response = Net::HTTP.start(members_uri.hostname, members_uri.port, use_ssl: members_uri.scheme == "https") do |http|
          http.request(members_request)
        end

        member_info = JSON.parse(members_response.body)

        if member_info["members_info"] && member_info["members_info"].first
          member_result = member_info["members_info"].first

          case member_result[".tag"]
          when "member_info"
            @raw_info ||= member_result
          when "id_not_found"
            error_message = "User email not found in Dropbox team: #{member_result["id_not_found"]}"
            raise OmniAuth::Error, error_message
          end
        end
      end

      def callback_url
        if @authorization_code_from_signed_request
          ""
        else
          options[:callback_url] || full_host + script_name + callback_path
        end
      end

      def request_phase
        session['dropbox_business_admin_email'] = request.params['dropbox_business_admin_email'] if request.params['dropbox_business_admin_email']
        super
      end

    end
  end
end
