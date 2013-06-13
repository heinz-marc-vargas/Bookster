class Account::SearchController < ApplicationController
  def index
    search_text = params[:query].downcase
    @search_text = search_text

    @company_count = current_user.companies.quick_search(search_text).count
    @branch_count = Company.find(session[:company_id]).branches.quick_search(search_text).count
    @staff_count = Company.find(session[:company_id]).staff.quick_search(search_text).count
    @user_count = User.quick_search(search_text).count
    @customer_count = Company.find(session[:company_id]).customers.quick_search(search_text).count
    #render :partial => "users/admin_search_summary"

    respond_to do |format|
      format.js
    end
  end
end