module Inpendium
  class PaymentVerification
    attr_reader :account_holder, :account_brand, :account_number, :account_bankname, :account_country,
                :account_authorisation, :account_verification, :account_year, :account_month,
                :payment_code, :payment_amount, :payment_usage, :payment_currency,
                :contact_email, :contact_mobile, :contact_ip, :contact_phone,
                :address_street, :address_zip, :address_city, :address_state, :address_country,
                :name_salutation, :name_title, :name_give, :name_family, :name_company

    CARDS = ['VISA', 'MASTERCARD', 'JCB']

    CREDENTIALS = {
    	:server =>   Settings.inpendium.server,
    	:path =>     Settings.inpendium.path,
    	:mode =>     Settings.inpendium.mode,
    	:currency => Settings.inpendium.currency,
    	:sender =>   Settings.inpendium.sender,
    	:channel =>  Settings.inpendium.channel,
    	:user =>     Settings.inpendium.user,
    	:password => Settings.inpendium.password,
    	:response => Settings.inpendium.response
    }

    DATA = {
      :test => {
        :payment_code => "CC.DB",
        :payment_information => {
          :payment_amount => "47.1",
          :payment_currency => "JPY",
          :identification_transaction_id => Digest::SHA2.hexdigest("#{Time.now.utc}#{rand(10000)}")
        },
        :account_information => {
          :account_holder => 'Bob Kosel',
          :account_brand => 'VISA',
          :account_number => '4111111111111111',
          :account_bank => '601613',
          :account_country => 'GB',
          :account_authorisation => "",
          :account_verification => '123',
          :account_year => '2014',
          :account_month => '10',

          :address_street => "Street 12-20",
          :address_city => "London",
          :address_country => "GB",

          :contact_email => "test@test.com",
          :contact_ip => "127.0.0.1",

          :name_family => "Kosel",
          :name_give => "Bob"
        }
      },
      :development => {
        :payment_code => "CC.DB",
        :payment_currency => Settings.inpendium.currency,
        :identification_transaction_id => Digest::SHA2.hexdigest("#{Time.now.utc}#{rand(10000)}")
      },
      :production => {
        :payment_code => "CC.DB",
        :payment_currency => Settings.inpendium.currency,
        :identification_transaction_id => Digest::SHA2.hexdigest("#{Time.now.utc}#{rand(10000)}")
      }
    }

    def self.cards_drop_down
      CARDS.collect{|card| [card, card]}
    end

    def self.expiration_month
      [
        ['01', '01'], ['02', '02'], ['03', '03'], ['04', '04'], ['05', '05'], ['06', '06'],
        ['07', '07'], ['08', '08'], ['09', '09'], ['10', '10'], ['11', '11'], ['12', '12']
      ]
    end

    def self.expiration_years
      [
        [2012, 2012], [2013, 2013], [2014, 2014], [2015, 2015], [2016, 2016], [2017, 2017], [2018, 2018],
        [2019, 2019], [2020, 2020], [2021, 2021], [2022, 2022], [2023, 2023], [2024, 2024], [2025, 2025],
        [2026, 2026], [2027, 2027], [2028, 2028], [2029, 2029], [2030, 2030], [2031, 2031], [2032, 2032],
        [2033, 2033], [2034, 2034], [2035, 2035], [2036, 2036], [2037, 2037], [2038, 2038], [2039, 2039],
        [2040, 2040], [2041, 2041], [2042, 2042]
      ]
    end

    def self.countries_drop_down
      [
        ['Australia', 'AU'],
        ['Austria', 'AT'],
        ['Belgium', 'BE'],
        ['Canada', 'CA'],
        ['China', 'CN'],
        ['Denmark', 'DK'],
        ['Finland', 'FI'],
        ['France', 'FR'],
        ['Germany', 'DE'],
        ['Hong Kong', 'HK'],
        ['Ireland', 'IE'],
        ['Italy', 'IT'],
        ['Japan', 'JP'],
        ['Korea', 'KR'],
        ['Luxembourg', 'LU'],
        ['Malaysia', 'MY'],
        ['Netherlands', 'NL'],
        ['New Zealand', 'NZ'],
        ['Norway', 'NO'],
        ['Philippines', 'PH'],
        ['Singapore', 'SG'],
        ['South Africa', 'ZA'],
        ['Spain', 'ES'],
        ['Sweden', 'SE'],
        ['Switzerland', 'CH'],
        ['Taiwan', 'TW'],
        ['Thailand', 'TH'],
        ['England', 'GB'],
        ['USA', 'US']
      ].sort
    end

    def initialize(params = {})
      @params = params

      @params.merge!(DATA[Rails.env.to_sym])
    end

    def payment
      @payment ||= Inpendium::XmlIntegrator.new(CREDENTIALS)
    end

    def perform
      params = keys_to_sym(@params)

      payment.set_payment_code(params[:payment_code])

      payment.set_payment_information(params)

      payment.set_account_information(params)

      payment.set_customer_address(params)

      payment.set_customer_contact(params)

      payment.set_customer_name(params)

      payment.commit_xml_payment
    end

    def keys_to_sym(hash)
      {}.tap do |result|
        hash.each do |key, value|
          result.merge!(key.to_sym => value)
        end
      end
    end

    def test_perform(params = {})
      payment.set_payment_code(DATA[:test][:payment_code])

    	payment.set_payment_information(DATA[:test][:payment_information])

      payment.set_account_information(DATA[:test][:account_information])

      payment.set_customer_address(DATA[:test][:account_information])

      payment.set_customer_contact(DATA[:test][:account_information])

      payment.set_customer_name(DATA[:test][:account_information])

    	payment.commit_xml_payment(params)
    end
  end
end