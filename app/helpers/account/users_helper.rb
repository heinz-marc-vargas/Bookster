module Account::UsersHelper
	def users_floating_header_table(users)
    letters = users.collect{ |u| u.first_name.first.upcase if u.first_name }.compact.uniq.sort

    letters.each do |letter|
    	select_users = users.select{|u| u.first_name.first.upcase == letter}

      yield(letter, select_users)
    end
	end

  def account_users_datable(params = {})
    users, total_count_records, total_count_display_records = users_list(params)

    {
      :iTotalRecords => total_count_records,
      :aaData => account_users_data(users),
      :iTotalDisplayRecords => total_count_display_records,
      :sEcho => params[:sEcho]
    }.to_json.html_safe
  end

  private

    def account_users_data(users)
      users.collect do |user|
        controlls = ""

        
        controlls << link_to_function("<i class='icon-eye-open'></i>".html_safe, "Application.load_content(Routes.account_user_path(#{user.id}))", :title => (t :user_view)) if can?(:read, Event)
        controlls << "&nbsp;"
        controlls << link_to_function("<i class='icon-pencil'></i>".html_safe, "Application.load_content(Routes.edit_account_user_path(#{user.id}))", :title => (t :user_edit)) if can?(:update, Event)
        controlls << "&nbsp;"
        controlls << link_to("<i class='icon-trash'></i>".html_safe, account_user_path(user),
                       :remote => true,
                       :method => :delete,
                       :confirm => t('user_delete_confirm')
                     ) if can?(:delete, User)

        [
          (user.first_name rescue "N/A"),
          (user.last_name rescue "N/A"),
          user.email,
          user.role,
          controlls
        ]
      end
    end	

    def users_list(params)
      users = User.for_manage
      total_count_records = users.count

      #searching
      if users.any? && params[:sSearch].present?
        users = users.where("first_name like ? OR last_name like ?", "%#{params[:sSearch]}%", "%#{params[:sSearch]}%")
      end

      total_count_display_records = users.count

      # pagination
      users = users.limit(params[:iDisplayLength].to_i).offset(params[:iDisplayStart].to_i) if users.any?

      # sorting by columns
      if users.any? && params[:iSortCol_0]
        users = users.order("#{sort_column(params[:iSortCol_0])} #{sort_direction(params[:sSortDir_0])} ")
      end

      [users, total_count_records, total_count_display_records]
    end	
    
    def sort_column(isortcol)
      columns = %w[first_name last_name email role]
      columns[isortcol.to_i]
    end
  
    def sort_direction(ssortdir)
      ssortdir == "desc" ? "desc" : "asc"
    end    
end
