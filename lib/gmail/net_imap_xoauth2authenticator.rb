require 'net/imap'

module Net
  class IMAP
    class Xoauth2Authenticator

      def process(data)
        build_oauth2_string(@user, @oauth2_token)
      end

    private

      # +user+ is an email address: roger@gmail.com
      # +oauth2_token+ is the OAuth2 token
      def initialize(user, oauth2_token)
        @user = user
        @oauth2_token = oauth2_token
      end

      def build_oauth2_string(user, oauth2_token)
        "user=%s\1auth=Bearer %s\1\1".encode("us-ascii") % [user, oauth2_token]
      end
    end
    add_authenticator('XOAUTH2', Xoauth2Authenticator)
  end
end
