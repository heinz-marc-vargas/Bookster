require 'socket'

class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"

    if Socket.gethostname == "michael.local"
      message.to = "mike@pagerise.com"
    else
      message.to = "jaredine@pagerise.com"
    end
  end
end
