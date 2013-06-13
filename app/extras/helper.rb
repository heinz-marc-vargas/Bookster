module Helper
  
  def self.clean_url(name)
    return "" if name.nil?
    name.gsub!(/(['"\/,;&^$%@!`~+:*#._()=])/, '')
    name.gsub!(" ", "")
    name.downcase.gsub(" ", "-")
  end

end