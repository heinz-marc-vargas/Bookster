# encoding: utf-8
module BranchesHelper
	def branches_datable(params = {})
		branches, total_count_records, total_count_display_records = branches_for_user(params)

    {
      :iTotalRecords => total_count_records,
      :aaData => branches_aa_data(branches),
      :iTotalDisplayRecords => total_count_display_records,
      :sEcho => params[:sEcho]
    }.to_json.html_safe
	end

  private

		def branches_aa_data(branches)
      branches.collect do |branch|

       # addresses
       addresses = %{
       	<div>
					<div>#{ branch.address_1 }</div>
					<div>#{ branch.address_2 }</div>
				  <div>#{ format("%d %s", branch.zipcode, branch.country.name) rescue "N/A" }</div>
				</div>
       }

      	# cotrols
      	controlls = ""
        controlls << link_to_function("<i class='icon-pencil'></i>".html_safe, "Application.load_content(Routes.edit_account_branch_path(#{branch.id}))") if can?(:update, branch)
			  controlls << link_to("<i class='icon-trash'></i>".html_safe, account_branch_path(branch.id),
                      :remote => true,
                      :method => :delete,
			                :confirm => "#{t('account.branches.confirm_delete')}" ) if can?(:delete, branch)
        image_url = branch.branch_logo.url(:thumb).nil? ? ((!File.exists?(branch.company.logo.wide.url)) ? "logos/default.png" : branch.company.logo.wide.url ) : branch.branch_logo.url(:thumb)

 
        [
          image_tag(image_url.to_s, :size=>"50x50"),
          branch.name,
          addresses,
          branches_operating_days(branch),
          controlls
        ]
      end
		end

		def branches_operating_days(branch)
			"".tap do |result|
	      branch.operating_days.each do |od|
					result << %{
						<div>
							<div style="float:left;text-align:right;width:100px">#{ Date::DAYNAMES[od.day_of_week] }&nbsp;&nbsp;</div>
							<span style="text-align:right;">#{ od.operating_time }</span>
						</div>
				  }
				 end
			end
		end

		def branches_for_user(params)
		  branches = current_user.branches_list(session[:company_id])

		  total_count_records = branches.count

      # searching
      if branches.any? && params[:sSearch].present?
        branches = branches.where("branches.name LIKE '%%%s%%' OR branches.subdomain LIKE '%%%s%%'", params[:sSearch], params[:sSearch])
      end

      total_count_display_records = branches.count

      # pagination
		  branches = branches.limit(params[:iDisplayLength].to_i).offset(params[:iDisplayStart].to_i) if branches.any?

      # sorting by columns
		  if branches.any? && params[:iSortCol_0] && params["bSortable_#{ params[:iSortCol_0] }".to_sym]
        branches = branches.order("branches.#{ branches_display_columns[params[:iSortCol_0].to_i] } #{ params[:sSortDir_0] }")
      end

		  [branches, total_count_records, total_count_display_records]
		end


		def branches_display_columns
      {
      	0 => :logo,
      	1 => :name,
      	2 => :subdomain,
      	3 => :addresses,
      	4 => :operating_days_and_hours,
      	5 => :actions
      }
		end
end
