module Inpendium
	module Integrate
		def payment_verification(params = {})
	    @payment_verification ||= Inpendium::PaymentVerification.new(params)
	  end
	end
end