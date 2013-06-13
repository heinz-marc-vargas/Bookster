class Customer < ActiveRecord::Base
  has_many :events
  belongs_to :company
  belongs_to :country
  has_one :user, :as => :resource
  has_many :notes, :as => :noteable
  has_many :review_links

  # validates :company_id, :presence => true
  # validates :country_id, :presence => true
  # validates :address_1, :presence => true
  # validates :address_2, :presence => true
  #validates_numericality_of :zipcode, :only_integer => true, :message => "must be a valid Zip Code"

  validates_associated :user

  scope :deleted, lambda {|deleted| {:conditions => ["customers.deleted = ?", deleted] }}
  scope :company, lambda {|company_id| {:conditions => ["customers.company_id = ?", company_id] }}
  scope :quick_search, lambda {|search_text|
    {
      :include => :user,
      :conditions => ["deleted = 0 AND (
                       lower(users.email) LIKE '%%%s%%' OR
                       lower(users.first_name) LIKE '%%%s%%' OR
                       lower(users.last_name) LIKE '%%%s%%' OR
                       lower(customers.address_1) LIKE '%%%s%%' OR
                       lower(customers.address_2) LIKE '%%%s%%')", search_text, search_text, search_text,
                                                                   search_text, search_text]
    }
  }

  scope :without_deleted, :conditions => {:deleted => 0}

  before_create :set_role_for_user

  def full_name
    return "" if user.nil?
    "#{user.full_name}"
  end
  
  def address
    address = []
    address << "#{address_1} #{address_2}"
    address << "#{zipcode}" unless zipcode.nil?
    address << country.name unless country.nil?
    address.join(" ")
  end

  def review_link(event)
    ReviewLink.where("customer_id = ? AND event_id = ?", self.id, event.id).first rescue nil
  end
  
  private

    def set_role_for_user
      unless self.user.nil?
        user.role = :customer
        user.save
      end
    end
 

end
