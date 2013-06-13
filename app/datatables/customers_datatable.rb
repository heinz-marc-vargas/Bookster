class CustomersDatatable
  delegate :session, :appt_account_customer_path, :current_user, :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: customers.count,
      iTotalDisplayRecords: customers.total_entries,
      aaData: data
    }
  end

private

  def data
    customers.map do |customer|
      [
        "customer-row-#{customer.id}",
        link_to((customer.user.full_name rescue ''), appt_account_customer_path(customer), :remote => true),
        (h(customer.user.email) rescue ''),
        actions(customer)
      ]
    end
  end

  def customers
    @customers ||= fetch_customers
  end

  def actions(customer)
    html = h(customer.created_at.strftime("%B %e, %Y"))
    html
  end
  
  def fetch_customers
    if current_user.admin?
      unless session[:company_id].nil?
        customers = Customer.where("company_id=?", session[:company_id])
      else
        customers = Customer.order("#{sort_column} #{sort_direction}")
      end
    else
      customers = Customer.where("company_id IN (?)", current_user.companies.map(&:id)).order("#{sort_column} #{sort_direction}")
    end
    
    customers = customers.page(page).per_page(per_page)
    if params[:sSearch].present?
      customers = customers.includes(:user).where("users.first_name like :search or users.last_name like :search or users.email like :search", search: "%#{params[:sSearch]}%")
    end
    customers
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[company_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end
end