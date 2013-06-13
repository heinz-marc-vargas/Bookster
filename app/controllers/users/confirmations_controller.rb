class Users::ConfirmationsController < Devise::ConfirmationsController
  layout 'login_screen'
  
  def show
    super

    if current_user.nil?
      redirect_to(root_path && return)
    else
      if current_user.role == "customer"
        current_user.update_attribute(:status, 1)
        company = current_user.resource.company
      else
        current_user.update_attribute(:status, 1)
        company = current_user.companies.first
        company.status          = 1
        company.progress_status = Company::STATUS[:details]
        company.plan_start_at   = Time.now
        company.plan_end_at     = company.plan_start_at + Company::PLANS[company.plan.to_sym][:duration]
        company.save
        company.init_notify_settings
      end

      flash[:notice] = t :successfully_activated
      sign_out(current_user)
    end
  end

  def after_confirmation_path_for(resource_name, resource)
    if Rails.env.development?
      if current_user.role == "customer"
        "#{current_user.resource.company.subdomain_url}/auth/users/sign_in?c=1"
      else
        "http://#{current_user.companies.first.subdomain}.#{request.domain}:#{request.port}/auth/users/sign_in?c=1"
      end
    else
      "http://#{current_user.companies.first.subdomain}.#{request.domain}"
    end
  end

end


