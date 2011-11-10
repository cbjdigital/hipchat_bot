require 'whois'

# A plugin that tells robut to retrieve whois information for a domain
class Robut::Plugin::DomainLookup
  include Robut::Plugin
  
  # Responds with +message+ if the command sent to robut is 'echo'.
  def handle(time, sender_nick, message)
    domains = words(message, 'whois')
    if sent_to_me?(message)
      domains.each do |domain|
        begin
          reply Whois.query(domain).to_s
        rescue Timeout::Error
          reply "Sorry #{sender_nick}, request timed out for #{domain}"
        rescue Whois::ServerNotFound
          reply "Sorry #{sender_nick}, Unable to find a WHOIS server for #{domain}"
        end
      end
    end
  end

  # Returns a description of how to use this plugin
  def usage
    "#{at_nick} whois <domain> - Returns the whois information about a domain"
  end

end
