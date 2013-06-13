module EventsHelper
	def events_datable(params = {})
		events, total_count_records, total_count_display_records = events_for_user(params)

    {
      :iTotalRecords => total_count_records,
      :aaData => events_aa_data(events),
      :iTotalDisplayRecords => total_count_display_records,
      :sEcho => params[:sEcho]
    }.to_json.html_safe
	end

  private

		def events_aa_data(events)
      events.collect do |event|
        next if event.customer.nil?

      	# controlls
      	controlls = ""
        controlls << link_to_function("<i class='icon-eye-open'></i>".html_safe, "Application.load_content(Routes.view_account_event_path(#{event.id}))", :title => (t :event_view)) if can?(:read, Event)
        controlls << "&nbsp;"
        controlls << link_to_function("<i class='icon-pencil'></i>".html_safe, "Application.load_content(Routes.edit_account_event_path(#{event.id}))", :title => (t :event_edit)) if can?(:update, Event)
        controlls << "&nbsp;"
        controlls << link_to("<i class='icon-trash'></i>".html_safe, account_event_path(event.id),
                       :remote => true,
                       :method => :delete,
                       :confirm => t("event_confirm_delete")
                     ) if can?(:delete, Event)
        controlls << "&nbsp;"
        controlls << link_to("<i class='icon-comment'></i>".html_safe, notes_account_event_path(event), 'data-target' => "#notesModal", :role => "button", "data-toggle" => "modal")


        [
          (event.branch.name rescue "N/A"),
          (event.service.name rescue "N/A"),
          (event.staff.user.full_name rescue "N/A"),
          (link_to(event.customer.full_name.titleize, account_customer_path(event.customer), 'data-target' => "#custModal", :role => "button", "data-toggle" => "modal")),
          (event.appointment_date),
          (event.appointment_span),
          (event.duration),
          controlls
        ]
      end
		end

		def events_for_user(params)
		  events = current_user.events_list

		  total_count_records = events.count

      unless params[:service_filter].blank?
        events = events.where("events.service_id = ?", params[:service_filter])
      end

      unless params[:staff_filter].blank?
        events = events.where("events.staff_id = ?", params[:staff_filter])
      end

        puts params[:start_date_filter]
        puts params[:end_date_filter]

      if !params[:start_date_filter].blank? && !params[:end_date_filter].blank?       
        events = events.where(
                  "DATE_FORMAT(events.starts_at, '%Y-%m-%d') >= ? AND DATE_FORMAT(events.ends_at,'%Y-%m-%d') <= ?",
                  form_date(params[:start_date_filter]),
                  form_date(params[:end_date_filter])
                )
      elsif !params[:start_date_filter].blank?
        events = events.where("events.starts_at >= ?", form_date(params[:start_date_filter]).to_date.strftime("%Y-%m-%d"))
      end

      #searching
      if events.any? && params[:sSearch].present?
        events = events.datable_searching(params[:sSearch])
      end

      total_count_display_records = events.count

      # pagination
		  events = events.limit(params[:iDisplayLength].to_i).offset(params[:iDisplayStart].to_i) if events.any?

      # sorting by columns
		  if events.any? && params[:iSortCol_0] && params["bSortable_#{ params[:iSortCol_0] }".to_sym]
        events = events_sorting(events, params)
      end

		  [events, total_count_records, total_count_display_records]
		end

    def events_sorting(events, params)
      case events_display_columns[params[:iSortCol_0].to_i]
      when :branch
        events.datable_sorting_by_branch(params[:sSortDir_0])
      when :service
        events.datable_sorting_by_service(params[:sSortDir_0])
      when :staff
        events.datable_sorting_by_staff(params[:sSortDir_0])
      when :customer
        events.datable_sorting_by_customer(params[:sSortDir_0])
      when :date
        events.datable_sorting_by_starts_at(params[:sSortDir_0])
      when :duration
        events.datable_sorting_by_duration(params[:sSortDir_0])
      end
    end

		def events_display_columns
      {
      	0 => :branch,
      	1 => :service,
      	2 => :staff,
      	3 => :customer,
      	4 => :date,
      	5 => :time,
      	6 => :duration,
      	7 => :actions
      }
		end
end
