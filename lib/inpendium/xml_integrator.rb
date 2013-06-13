require 'builder'
require 'rexml/document'

module Inpendium
  class XmlIntegrator
    def initialize(options = {})
      @server               = options[:server]
      @path                 = options[:path]
      @sender               = options[:sender]
      @channel              = options[:channel]
      @userid               = options[:user]
      @userpwd              = options[:password]
      @transaction_mode     = options[:mode]
      @transaction_response = options[:response]
      @request_version      = "1.0"
    end

    def set_payment_code(code)
      @payment_code = code
    end

    def set_payment_information(values = {})
      @payment_amount   =  values[:payment_amount]
      @payment_usage    =  values[:payment_usage]
      @payment_currency =  values[:payment_currency]
      @identification_transaction_id = values[:identification_transaction_id]
    end

    def set_account_information(values = {})
      @account_holder        = values[:account_holder]
      @account_brand         = values[:account_brand]
      @account_number        = values[:account_number]
      @account_bank          = values[:account_bank]
      @account_country       = values[:account_country]
      @account_authorisation = values[:account_authorisation]
      @account_verification  = values[:account_verification]
      @account_year          = values[:account_year]
      @account_month         = values[:account_month]
    end

    def set_customer_contact(values = {})
      @contact_email  = values[:contact_email]
      @contact_mobile = values[:contact_mobile]
      @contact_ip     = values[:contact_ip]
      @contact_phone  = values[:contact_phone]
    end


    def set_customer_address(values = {})
      @address_street  = values[:address_street]
      @address_zip     = values[:address_zip]
      @address_city    = values[:address_city]
      @address_state   = values[:address_state]
      @address_country = values[:address_country]
    end

    def set_customer_name(values = {})
      @name_salutation = values[:name_salutation]
      @name_title      = values[:name_title]
      @name_give       = values[:name_give]
      @name_family     = values[:name_family]
      @name_company    = values[:name_company]
    end

    def send_to_ctpe(str_xml)
      Curl::Easy.new("https://#{ @server }#{ @path }").tap do |curl|
        curl.headers["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8"
        curl.useragent = "ruby ctpepost"
        curl.ssl_verify_host = 1
        curl.ssl_verify_peer = false
        curl.http_post(Curl::PostField.content('load', str_xml))
      end
    end

    def build_xml
      str_xml = ""

      xml = Builder::XmlMarkup.new(:target => str_xml, :indent => 2)
      xml.instruct!

      xml.Request(:version => @request_version) do
        xml.Header do
          xml.Security(:sender => @sender, :token => "token", :type => "MERCHANT")
        end

        xml.Transaction(:response => @transaction_response, :channel => @channel, :mode => @transaction_mode) do
          xml.User(:pwd => @userpwd, :login => @userid)

          xml.Identification do
            xml.TransactionID @identification_transaction_id
          end

          xml.Payment(:code => @payment_code) do
            xml.Presentation do
              xml.Amount   @payment_amount
              xml.Usage    @payment_usage
              xml.Currency @payment_currency
            end
          end

          xml.Account do
            xml.Holder        @account_holder
            xml.Brand         @account_brand
            xml.Number        @account_number
            xml.Bank          @account_bank
            xml.Country       @account_country
            xml.Authorisation @account_authorisation
            xml.Verification  @account_verification
            xml.Year          @account_year
            xml.Month         @account_month
          end

          xml.Customer do
            xml.Contact do
              xml.Email  @contact_email
              xml.Mobile @contact_mobile
              xml.Ip     @contact_ip
              xml.Phone  @contact_phone
            end

            xml.Address do
              xml.Street  @address_street
              xml.Zip     @address_zip
              xml.City    @address_city
              xml.State   @address_state
              xml.Country @address_country
            end

            xml.Name do
              xml.Salutation @name_salutation
              xml.Title      @name_title
              xml.Given      @name_give
              xml.Family     @name_family
              xml.Company    @name_company
            end
          end
        end
      end

      str_xml
    end

    def commit_xml_payment(options = {})
      data_xml = build_xml

  	  result = send_to_ctpe(data_xml)

      if result.response_code == 200
        write_to_logger(data_xml, result)

        options[:return_xml] ? result.body_str : parser_result(result.body_str)
      else
        Rails.logger.fatal("Error request to the server #{@server} for #{@contact_ip} at #{Time.now}. Response code: #{result.response_code}.")
      end
    end

    def parser_result(result_xml)
      result = {}

      xml = REXML::Document.new(result_xml)

      result[:result] = xml.elements['//Processing/Result'].text
      result[:status] = {
        :code => xml.elements['//Processing/Status'].attribute("code"),
        :text => xml.elements['//Processing/Status'].text
      }
      result[:reason] = {
        :code => xml.elements['//Processing/Reason'].attribute("code"),
        :text => xml.elements['//Processing/Reason'].text
      }
      result[:status] = {
        :code => xml.elements['//Processing/Return'].attribute("code"),
        :text => xml.elements['//Processing/Return'].text
      }

      result
    end

    def write_to_logger(data_xml, result)
      message = %{
        NEW TRANSACTION - BEGIN at #{Time.now} ------------------------------------------------------------------------
        #{Time.now} sent data = 
        #{data_xml}
        #{Time.now} response data = 
        #{result.body_str}
        NEW TRANSACTION - END at #{Time.now} ---------------------------------------------------------------------------
      }

      Rails.logger.info(message)
    end
  end
end