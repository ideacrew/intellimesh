# frozen_string_literal: true

module Intellimesh
  module Adapters
    class Adapter
      # Provide a unique symbol to identify this adapter in URI addresses
      URI_SCHEME = nil

      def initialize
        register(self)
      end

      # Add adapter to URI
      def register(adapter_klass)
# module URI
#   class RSYNC < Generic
#     DEFAULT_PORT = 873
#   end
#   @@schemes['RSYNC'] = RSYNC
# end

# #=> URI::RSYNC

# URI.scheme_list
# #=> {"FTP"=>URI::FTP, "HTTP"=>URI::HTTP, "HTTPS"=>URI::HTTPS,
#      "LDAP"=>URI::LDAP, "LDAPS"=>URI::LDAPS, "MAILTO"=>URI::MailTo,
#      "RSYNC"=>URI::RSYNC}

# uri = URI("rsync://rsync.foo.com")
# #=> #<URI::RSYNC:0x00000000f648c8 URL:rsync://rsync.foo.com>
      end
    end
  end
end
