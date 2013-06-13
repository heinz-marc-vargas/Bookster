class Subdomain
	def initialize(resource)
    @resource = resource
	end

  def matches?(request)
  	case @resource.to_sym
  	when :company
      request.subdomain.present? && request.subdomain != "www" && request.subdomain.split(".").size == 1
    when :branch
      request.subdomain.present? && request.subdomain != "www" && request.subdomain.split(".").size == 2
    else
      false
    end
  end
end