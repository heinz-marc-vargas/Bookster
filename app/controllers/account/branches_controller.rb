class Account::BranchesController < ApplicationController
  before_filter :authenticate_user!
    before_filter :load_company
  
  layout false, :only => [:index]
  
  def index
    session[:active_main_tab] = 'branches'
    
    if (@company != nil)
      @branches = @company.branches
    end
    
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @branch = Branch.new

    render :layout => false
  end

  def edit
    @branch = Branch.find(params[:id])

    render :layout => false
  end

  def create
    @branch = params[:branch] != nil ? Branch.new(params[:branch]) : Branch.new
    if @branch.save
      save_operating_times(params)

      unless params[:logo].nil?
        @branch.branch_logo = params[:logo]
      end
      @success = format("New branch for %s has been added.", @branch.company.name)
    end

    respond_to do |format|
      format.js
      format.html { redirect_to account_dashboard_path(:path => "/account/branches" )}
    end
  end

  def update
    @branch = Branch.find(params[:branch][:id])
    @branch.update_attributes(params[:branch])    
    unless params[:logo].nil?
      @branch.branch_logo = params[:logo]
    end

    if @branch.save
      save_operating_times(params)
      @branch.reload
      
      if !@branch.operating_days.empty? && @branch.company.progress_status != 'complete'
        @branch.company.next_status('complete')
      end
      
      @success = format("Changes to %s branch have been saved.", @branch.company.name)
    end

    respond_to do |format|
      format.html { redirect_to account_dashboard_path(:path => account_branches_path.to_s, :company_id => @branch.company_id) }
      format.js
    end
  end

  def destroy
    branch = Branch.find(params[:id])
    branch.deleted = 1
    branch.save
    @success = format("Branch has been deleted.")

    respond_to do |format|
      format.js
    end
  end

  def save_operating_times(params)
    @branch.operating_days.destroy_all
    0.upto(6) do |i|
      if (params["openday_" + i.to_s] != nil)
        oh = OperatingHour.new
        oh.am_start_time = params["start_time_am_" + i.to_s]
        oh.am_end_time = params["end_time_am_" + i.to_s]
        oh.pm_start_time = params["start_time_pm_" + i.to_s]
        oh.pm_end_time = params["end_time_pm_" + i.to_s]
        oh.save
        od = OperatingDay.new
        od.day_of_week = i
        od.resource = @branch
        od.operating_hour = oh
        od.save
      end
    end
  end
end
