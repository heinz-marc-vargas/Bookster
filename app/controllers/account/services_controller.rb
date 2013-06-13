class Account::ServicesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_company
  layout false, only: [:index, :show]

  def index
    session[:active_main_tab] = "services"
  end

  def move_down
    @service = Service.find(params[:id])
    services = Service.where("branch_id = ?", @service.branch_id).order("sequence_no ASC")
    index = services.index(@service)

    unless services[index+1].nil?
      seqno = @service.sequence_no
      @service.update_attribute(:sequence_no, services[index+1].sequence_no)
      services[index+1].update_attribute(:sequence_no, seqno)
    end
    
    respond_to do |format|
      format.html
      format.js
      format.json { @service.to_json }
    end
  end
  
  def move_up
    @service = Service.find(params[:id])
    services = Service.where("branch_id = ?", @service.branch_id).order("sequence_no ASC")
    index = services.index(@service)

    unless services[index-1].nil?
      seqno = @service.sequence_no
      @service.update_attribute(:sequence_no, services[index-1].sequence_no)
      services[index-1].update_attribute(:sequence_no, seqno)
    end
    
    respond_to do |format|
      format.html
      format.js
      format.json { @service.to_json }
    end
  end
    
  def list_datable
    respond_to do |format|
      format.json
    end
  end

  def new
    @service = Service.new
    services = Service.where("branch_id IN (?) AND service_category_id is not null", @company.branches.map(&:id))
    @categories = ServiceCategory.where("id IN (?)", services.map(&:service_category_id))
    if current_user.admin?
      @branches = Branch.order("company_id ASC, name ASC")
    else
      @branches = @company.branches      
    end
     
    render :layout => false
  end

  def edit
    @service = Service.find(params[:id])
    services = Service.where("branch_id IN (?) AND service_category_id is not null", @company.branches.map(&:id))
    @categories = ServiceCategory.where("id IN (?)", services.map(&:service_category_id))
    if current_user.admin?
      @branches = Branch.order("company_id ASC, name ASC")
    else
      @branches = @company.branches      
    end
    
    render :layout => false
  end

  def show
    @service = Service.find(params[:id])
  end

  def create
    if current_user.admin?
      @branches = Branch.order("company_id ASC, name ASC")
    else
      @branches = @company.branches      
    end
    
    @service = params[:service] != nil ? Service.new(params[:service]) : Service.new
    services = Service.where("branch_id IN (?) AND service_category_id is not null", @company.branches.map(&:id))
    @categories = ServiceCategory.where("id IN (?)", services.map(&:service_category_id))

    if current_user.admin?
      @branches = Branch.order("company_id ASC, name ASC")
    else
      @branches = @company.branches      
    end
        
    if params[:service][:service_category_id].to_s == "0"
      cat = ServiceCategory.create(:name => params[:new_category])
      @service.service_category_id = cat.id
    end

    if @service.save!
      save_staff(params, @service.id)
      @success = format((t :service_added_new), @service.name, @company.name)
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    @service = Service.find(params[:service][:id])
    if params[:service][:service_category_id].to_s == "0"
      cat = ServiceCategory.create(:name => params[:new_category])
      @service.service_category_id = cat.id
    end    

    if @service.update_attributes(params[:service])
      save_staff(params, @service.id)
      @success = format((t :service_saved), @service.name)
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    service = Service.find(params[:id])
    service.deleted = 1
    service.save
    @success = I18n.t('services.delete.success', :name => service.name)

    respond_to do |format|
      format.js
    end
  end

  def save_staff(params, service_id)
    service = Service.find(service_id)
    service.staff = []

    params[:staff].each do |staff_id|
      staff = Staff.find(staff_id) rescue nil
      staff.services << service unless staff.nil?
    end

  end

  def mass_update
    ids = Array.new
    count = 0
    params.each do |p|
      if p[0][0..5] == "check_"
        s = Service.find(p[1].to_i)
        s.deleted = 1
        s.save
        count += 1
      end
    end
    format_string = (params[:action_id] == "0") ? (t :service_mass_deleted) : (t :service_mass_updated)
    @success = format(format_string, count)

    respond_to do |format|
      format.js
    end
  end
end