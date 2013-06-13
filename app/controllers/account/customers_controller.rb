class Account::CustomersController < ApplicationController
  before_filter :authenticate_user!
  layout false, only: [:index, :show]

  def index
    @company = Company.find(session[:company_id]) rescue nil
    session[:active_main_tab] = "customers"
    #customer_ids = session[:company_id] ? Company.find(session[:company_id]).customers.without_deleted : Customer.where("id = 0")
    #@users = User.by_customer_ids(customer_ids)
    
    respond_to do |format|
      format.html
      format.json { render json: CustomersDatatable.new(view_context) }
    end    
  end

  def export
    require 'spreadsheet'
    Spreadsheet.client_encoding = 'UTF-8'
    workbook = Spreadsheet::Workbook.new
    sheet1 = workbook.create_worksheet name: "Sheet1"
    headers = [ 'Customer name', 'Email', 'Phone Number', 'Street', 'Zipcode', 'State', 'Country' ]
    sheet1.row(0).replace headers
    number_format = Spreadsheet::Format.new :number_format => '0'
    
    #setting column width
    sheet1.column(0).width = 10
    sheet1.column(1).width = 15
    sheet1.column(2).width = 15
    sheet1.column(3).width = 15
    sheet1.column(4).width = 17
    sheet1.column(5).width = 17
    sheet1.column(6).width = 17
    
    row_id = 1
    current_user.companies.first.customers.each_with_index do |cust, indx|
      customer_row = []
      
      customer_row << cust.full_name
      customer_row << cust.user.email rescue "--"
      customer_row << cust.phone_number rescue "--"
      customer_row << cust.address_1 rescue "--"
      customer_row << cust.zipcode rescue "--"
      customer_row << 'state'
      customer_row << cust.country.name rescue "--"
      
      sheet1.row(row_id).replace customer_row
      row_id += 1
    end
    
    filename = "customers.xls"
    workbook.write(Rails.root + filename)
    send_file filename, :type => 'application/vnd.ms-excel', :disposition => 'attachment'
  end
  
  def notes
    if request.post?
      @customer = Customer.find(params[:id])
      @note = Note.create(:noteable => @customer, :contents => params[:notes])
    end
    
    respond_to do |format|
      format.js
    end  
  end
  
  def appt
    @customer = Customer.find(params[:id])
    
    respond_to do |format|
      format.js
    end  
  end
  
  def filter
    session[:active_main_tab] = "customers"
    search_text = params[:search_text].downcase
    @customers = scoped_list(params, search_text)
    render :layout => false
  end

  # def scoped_list(params = nil, search_text = nil)
  #   customers = Company.find(session[:company_id]).customers.scoped
  #   customers = search_text ? customers.quick_search(search_text) : customers.deleted(0)
  #   session[:current_page] = params[:page] ? params[:page] : 0
  #   return customers.paginate(:page => params[:page], :per_page => session[:per_page]) 
  # end

  def new
    @customers = Customer.new
    render :layout => false
  end

  def edit
    @customer = Customer.find(params[:id])
    render :layout => false
  end
  
  def show
    @customer = Customer.find(params[:id])
  end

  def create
    @customer = params[:customer] != nil ? Customer.new(params[:customer]) : Customer.new
    @customer.save
    session[:customer_id] = @customer.id
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    customer = Customer.find(params[:id])
    customer.deleted = 1
    customer.save
    @success = format((t :customer_deleted), customer.full_name)

    respond_to do |format|
      format.js
    end
  end

  def mass_update
    ids = Array.new
    count = 0
    params.each do |p|
      if p[0][0..5] == "check_"
        s = Customer.find(p[1].to_i)
        s.deleted = 1
        s.save
        count += 1
      end
    end
    format_string = (params[:action_id] == "0") ? (t :customer_mass_deleted) : (t :customer_mass_updated)
    @success = format(format_string, count)
    @customers = scoped_list(params)
    render :action => "list"
  end
end

