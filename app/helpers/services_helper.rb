module ServicesHelper
	def services_datable(params = {})
		services, total_count_records, total_count_display_records = services_for_user(params)

    {
      :iTotalRecords => total_count_records,
      :aaData => services_aa_data(services),
      :iTotalDisplayRecords => total_count_display_records,
      :sEcho => params[:sEcho]
    }.to_json.html_safe
	end

  private

		def services_aa_data(services)
      services.collect do |service|

      	# controlls
      	controlls = ""
        controlls << link_to_function("<i class='icon-eye-open'></i>".html_safe, "Application.load_content(Routes.account_service_path(#{service.id}))", :title => (t :service_view)) if can?(:read, Service)
        controlls << "&nbsp;"
        
        if can?(:update, service)
					controlls << link_to_function("<i class='icon-pencil'></i>".html_safe, "Application.load_content(Routes.edit_account_service_path(#{service.id}))", :title => (t :service_edit))
          controlls << "&nbsp;"
				end

				if can?(:delete, service)
					controlls << link_to("<i class='icon-trash'></i>".html_safe, account_service_path(service.id),
                        :remote => true,
                        :method => :delete,
								        :confirm => t('service_confirm_delete')
						           )
          controlls << "&nbsp;"
				end
				
				if !current_user.admin?
				  controlls << link_to(raw("<i class=\"icon-circle-arrow-up\"></i>"), "#", :class => "move_up", "data-id" => service.id, :title => "Move up")
          controlls << "&nbsp;"
				  controlls << link_to(raw("<i class=\"icon-circle-arrow-down\"></i>"), "#", :class => "move_down", "data-id" => service.id, :title => "Move down")
        end
      
        [
        	check_box_tag("check_" + service.id.to_s, service.id, false, :class => "mass_check"),
        	service.name,
        	service.description,
        	service.duration,
        	service.charge,
          controlls
        ]
      end
		end

		def services_for_user(params)
		  services = current_user.services_list.without_deleted

		  total_count_records = services.count

      # searching
      if services.any? && !params[:sSearch].blank?
        services = services.where("services.name LIKE '%%%s%%' OR services.description LIKE '%%%s%%'", params[:sSearch], params[:sSearch])
      end

      total_count_display_records = services.count

      # pagination
		  services = services.limit(params[:iDisplayLength].to_i).offset(params[:iDisplayStart].to_i) if services.any?

      # sorting by columns
		  if services.any? && params[:iSortCol_0] && params["bSortable_#{ params[:iSortCol_0] }".to_sym]
        services = services.order("services.#{ services_display_columns[params[:iSortCol_0].to_i] } #{ params[:sSortDir_0] }")
      end

		  [services, total_count_records, total_count_display_records]
		end


		def services_display_columns
      {
      	0 => :check_box,
      	1 => :name,
      	2 => :description,
      	3 => :duration,
      	4 => :charge,
      	5 => :actions
      }
		end
end
