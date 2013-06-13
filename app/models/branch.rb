class Branch < ActiveRecord::Base
  belongs_to :company
  belongs_to :country

  has_many :staff, :dependent => :destroy
  #has_many :operating_days, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :services
  has_many :closed_dates, :as => :blockable, :dependent => :destroy
  has_many :reviews
  has_many :operating_days, :as => :resource, :dependent => :destroy
  has_many :notes, :as => :noteable, :dependent => :destroy
  mount_uploader :branch_logo, LogoUploader


  validates :company_id, :presence => true
  #validates :country_id, :presence => true
  #validates :address_1, :presence => true
  #validates :address_2, :presence => true
  validates :name, :presence => true
  #validates :zipcode, :presence => true
  #validates_numericality_of :zipcode, :only_integer => true, :message => "must be a valid Zip Code"

#  validates :subdomain,
#    :presence => true,
#    :uniqueness => {:case_sensitive => false},
#    :exclusion => {
#      :in => %w(www us jp en ja),
#      :message => "Subdomain %{value} is reserved."
#    },
#    :format => { :with => /[a-z0-9_-]+/ }

  scope :quick_search, lambda {|search_text| {:conditions => ["lower(branches.name) LIKE '%%%s%%'", search_text] }}
  scope :without_deleted, :conditions => {:deleted => 0}

  serialize :notify_options


  def subdomain=(value)
    gsub_pattern = /[\W_]+/
    slice_pattern = /((-*)[a-z0-9])+/i

    self[:subdomain] = value.gsub(gsub_pattern, "-").slice(slice_pattern).try(:downcase)
  end
  
  def init_notify_settings
    self.notify_enabled = true  
      self.notify_options = {
        :email => self.company.users.first.email,
        :frequency => "everytime",
      }
    self.save    
  end
  
  def address
    address = []
    address12 = "#{address_1} #{address_2}".strip
    address << "#{address12}" unless address12.blank?
    address << "#{city}" unless city.blank?
    address << "#{state}" unless state.blank?
    address << "#{zipcode}" unless zipcode.blank?
    address << "#{country.name}" unless country_id.nil?
    address.join(", ")
  end
  
  def holidays_dates
    self.closed_dates.map(&:start_date_time).collect{|d| "#{d.month.to_i}-#{d.day.to_i}-#{d.year.to_i}" }.join(",")
  end
  
  def off_days_of_week
    [0,1,2,3,4,5,6] - self.operating_days.map(&:day_of_week)
  end
end
