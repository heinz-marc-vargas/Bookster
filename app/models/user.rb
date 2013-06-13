#require "digest/sha1"

class User < ActiveRecord::Base
  ROLES_FOR_RESOURCES = [:staff, :customer]
  MAIN_ROLES = [:admin, :owner]

  ROLES = MAIN_ROLES + ROLES_FOR_RESOURCES

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable,
         :omniauthable, :recoverable, :registerable, :confirmable, request_keys: [:subdomain]

  has_and_belongs_to_many :companies
  #has_one :company
  has_many :branches, :through => :companies
  has_many :services, :through => :companies
  has_many :events,   :through => :companies
  belongs_to :country

  belongs_to :resource, :polymorphic => true, :dependent => :destroy

  #validates :username, :length => { :within => 5..25 }, :uniqueness => true
  #validates :first_name, :presence => true, :length => { :maximum => 20 }
  #validates :last_name,  :presence => true, :length => { :maximum => 20 }

  scope :quick_search, lambda {|search_text|
    {:conditions => ["lower(users.username) LIKE '%%%s%%' OR
                         lower(users.email) LIKE '%%%s%%' OR
                         lower(users.first_name) LIKE '%%%s%%' OR
                         lower(users.last_name) LIKE '%%%s%%'", search_text, search_text,
                                                                search_text, search_text]
    }
  }

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username, :first_name, :last_name, :role, :id, :country_id,
                  :company_subdomain, :billing_plan, :gender

  scope :for_manage, :conditions => {:role => [:admin, :owner]}

  scope :by_staff_ids, Proc.new{|staff_ids|
    {
      :conditions => ["users.resource_id IN (?) AND resource_type = ?", staff_ids, Staff.sti_name]
    }
  }

  scope :by_customer_ids, Proc.new{|customer_ids|
    {
      :conditions => ["users.resource_id IN (?) AND resource_type = ?", customer_ids, Customer.sti_name]
    }
  }

  #validate :check_company_subdomain, :on => :create
  validates :role, :presence => true

  before_create :set_company_owner_role, :if => :company_subdomain
  after_save :send_confirmation_email
  
  mount_uploader :avatar, AvatarUploader

  def self.find_for_authentication(warden_conditions)
    company = Company.find_by_subdomain(warden_conditions[:subdomain])
    Rails.logger.info(warden_conditions[:email])
    user = User.where("email=?", warden_conditions[:email]).first
    Rails.logger.info("User: #{user.inspect}")
    return nil if user.nil?
    
    if user.role == "customer"
      user
    else
      company.users.where("email = ?", warden_conditions[:email]).first
    end
  end

  def self.from_omniauth(auth)
    user = User.find_by_email(auth.info.email)

    if !user
      User.transaction do
        User.new.tap do |user|
          user.uid = auth.uid
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name
          user.email = auth.info.email
          user.oauth_token = auth.credentials.token
          user.oauth_expires_at = Time.at(auth.credentials.expires_at)
          user.save

          Customer.create(:user => user, :phone_number => '')
        end
      end
    else
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save

      user
    end
  end

  def password_required?
    (new_record? && resource_type != Customer.sti_name) || (!password.blank? && super)
  end

  def full_name
    if self.first_name.nil?
      self.email
    else
      "#{self.first_name} #{self.last_name}"
    end
  end

  def role=(value)
    self[:role] = value if ROLES.include?(value.to_sym)
  end

  def has_role?(value)
    value ? value.to_sym == role.to_sym : false
  end

  def can_add_new_branch?
    case role.to_sym
    when :admin
      true
    when :owner
      companies.without_deleted.each  do |company|
        return true if company.available_for_new_branch?
      end

      false
    else
      false
    end
  end

  def companies_for_new_branch
    [].tap do |result|
      companies.without_deleted.each do |company|
        result << company if company.available_for_new_branch?
      end
    end
  end

  def branches_list(company_id=nil)
    case role.to_sym
    when :admin
      if company_id.nil?
        Branch.scoped
      else
        Branch.where("company_id=?", company_id)
      end
    when :owner
      branches.without_deleted
    when :staff
      Branch.without_deleted.where("id in (?)", resource.branch_id)
    end
  end

  def branches_list_by_company_id(company_id)
    case role.to_sym
    when :admin
      if company = Company.find_by_id(company_id)
        company.branches
      end
    when :owner
      company = Company.find(company_id)
      company.branches
    when :staff
      resource.branch.company.branches
    else
      Branch.where('id = 0')
    end
  end

  def services_list_by_company_id(company_id)
    case role.to_sym
    when :admin
      if company = Company.find_by_id(company_id)
        company.services
      end
    when :owner
      company = Company.find(company_id)
      company.services
    when :staff
      resource.branch.company.services
    else
      Service.where('id = 0')
    end
  end

  def events_list
    case role.to_sym
    when :admin
      Event.includes(:branch, :customer, :service, :staff => :user ).scoped
    when :owner
      events.includes(:branch, :customer, :service, :staff => :user ).order("starts_at")
    when :staff
      resource.events
    else
      Event.where('id = 0')
    end
  end

  def event_ids
    events_list.collect{|e| e.id}
  end

  def services_list
    case role.to_sym
    when :admin
      Service.scoped
    when :owner
      services.order("sequence_no ASC")
    when :staff
      resource.services
    else
      Service.where('id = 0')
    end
  end

  def service_ids
    services_list.collect{|s| s.id}
  end

  def unassigned_company_drop_down
    Company.unassigned([company]).collect{|c| [c.name, c.id]}
  end

  def staff_list(company_id = nil, all = false)
    case role.to_sym
    when :admin
      if company_id && company = Company.find_by_id(company_id)
        company.staffs
      elsif all
        Staff.includes(:user)
      else
        Staff.where('id = 0')
      end

    when :owner
      branches = []
      companies.each{|c| branches += c.branches }
      puts branches.inspect
      
      unless branches.empty?
        Staff.where("branch_id IN (?)", branches.map(&:id))
      else
        Staff.where('id = 0')
      end

    when :staff
      Staff.where("id in (?)", resource_id)
    else
      Staff.where('id = 0')
    end
  end

  def companies_list
    case role.to_sym
    when :admin
      Company.scoped
    when :owner
      companies
    else
      Company.where('id = 0')
    end
  end

  def company_subdomain
    @company_subdomain
  end

  def company_subdomain=(value)
    @company_subdomain = value
  end

  def billing_plan
    @billing_plan
  end

  def billing_plan=(value)
    @billing_plan = value
  end
  
  def user?
    self.role == "owner" 
  end
  alias :owner? :user?
  
  def staff?
    self.role == "staff"
  end
  
  def admin?
    self.role == "admin"
  end
  
  def is_customer?
    self.role == "customer"
  end
  
  def user_or_staff?
    (self.role == "owner" || self.role == "staff")
  end

  def company_name
    return "" if company.nil?
    company.name.titleize
  end
  
  def review_list
    puts self.role.to_s
    reviews = case self.role.to_s
    when "admin"
      Review.order("created_at DESC")
    when "owner", "staff"
      Review.where("branch_id IN (?)", branches.map(&:id)).order("created_at DESC")
    else
      []
    end
    
    reviews
  end

  def appointments
    if self.role == "customer"
      Event.where("customer_id = ?", self.resource_id)
    else
      branches = []

      self.companies.each do |c|
        branches += c.branches
      end
      
      Event.where("branch_id IN (?)", branches.uniq.map(&:id))
    end
  end
  
  private

    def check_company_subdomain
      if company_subdomain
        #company = companies.build
        #company.subdomain = company.name = company_subdomain
        
        #company.plan = billing_plan
        #company.plan_start_at = Time.now
        #company.plan_end_at = company.plan_start_at + Company::PLANS[billing_plan.to_sym][:duration]

        #errors.add(:company_subdomain, company.errors[:subdomain]) unless company.valid?
      end
    end

    def set_company_owner_role
      self.role = :owner
    end
    
    def send_confirmation_email
      if self.confirmed_at_changed? ## && self.role != "staff"
        puts "Email has change..."
        Mailer.account_confirmed(self).deliver
      else
        puts "not changed or the user is a staff.."
      end
    end
end
