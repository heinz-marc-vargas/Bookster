class Account::CompaniesController < ApplicationController
  before_filter :authenticate_user!
  layout false, :only => [:index, :edit, :new]
  before_filter :load_company, :only => [:details, :notifications, :closedate, :buttons]

  def open
    session[:company_id] = params[:id]
    @company = Company.find(params[:id])
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_cdate
    @cdate = ClosedDate.find(params[:id])
    @cdate.destroy
    
    respond_to do |format|
      format.js
      format.html
    end  
    
  end
  
  def generate_code
    @branch_id = params[:branch_id] rescue nil
    @service_id = params[:service_id] rescue nil
    @service = Service.find(@service_id) rescue nil
    @branch = Branch.find(@service.branch_id) unless @service.nil?
    
    respond_to do |format|
      format.js
    end
  end
  
  def buttons
    if current_user.admin?
      @branches = Branch.order("company_id ASC, name ASC")
    else
      @branches = @company.branches      
    end
    @services = Service.where("branch_id IN (?)", @branches.map(&:id))    
  end
  
  def closedate
    @cdate = ClosedDate.new
    @closed_dates = []
    
    if request.post?
      @cdate = ClosedDate.create_cdate(params[:branch][:branch_id], params, 'Branch')
      if @cdate.errors.empty? && @company.status != 'complete'
      end
    end
    
    #@closed_dates = ClosedDate.where("blockable_id IN (?) AND blockable_type = 'Branch'", @company.branches.map(&:id))
    @closed_dates = ClosedDate.where("blockable_id IN (?) AND blockable_type = 'Branch'", current_user.branches_list.map(&:id))
    Rails.logger.info("### CLOSED DATES: " + @closed_dates.inspect)
    
    respond_to do |format|
      format.js
      format.html
    end

  end
  
  def details
    @saved = false
    
    if request.put?
      if @company.update_attributes(params[:company])
        @saved = true
      end
    end
    
    respond_to do |format|
      format.js
      format.html { redirect_to account_dashboard_path(:path => "/account/companies/details") if @saved }
    end
  end
  
  def notifications
    @branch = @company.branches.first

    if request.post?
      if params[:enable].nil?
        @branch.update_attribute(:notify_enabled, 0)
      else
        @branch.notify_enabled = params[:enable]
        @branch.notify_options = { :email => params[:email], :frequency => params[:frequency] }
        @branch.save
      end

    end
    
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def index
    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @company = Company.find_by_subdomain(request.subdomain) || Company.last
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company])

    if @company.save
      @success = format("New company has been added.", @company.name)
    end
    
    respond_to do |format|
      format.js
      format.html { redirect_to root_path( :open => 'companies') }
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])

    if @company.update_attributes(params[:company])
      if params[:logo]
        upload_photo(params[:logo])
        @company.logo = params[:logo].original_filename
        @company.save
      end

      @success = format("Changes to %s branch have been saved.", @company.name)
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    company = Company.find(params[:id])
    company.deleted = 1
    company.save
    @success = I18n.t('companies.delete.success', :name => company.name)

    respond_to do |format|
      format.js
    end
  end
end
