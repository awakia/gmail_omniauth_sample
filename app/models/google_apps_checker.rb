require 'net/http'
require 'uri'

class GoogleAppsChecker
  MAX_RETRY = 5
  def self.is_gmail(host_name)
    uri = URI.parse("https://www.google.com/a/cpanel/#{host_name}/Dashboard")
    result = nil
    MAX_RETRY.times do
      result = Net::HTTP.get_response(uri)
      if result.is_a? Net::HTTPRedirection
        uri = URI.parse(result['Location'])
      else
        break
      end
    end
    result.body =~ /<title>(.*)<\/title>/
    if $1 == "Google Apps"
      return true
    elsif $1 == "Server error"
      return false
    else
      puts "Unknown title: " + $1
      return false
    end
  end
end
