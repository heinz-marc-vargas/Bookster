# encoding: utf-8
module CompaniesHelper
  def companies_datable(params = {})
    companies, total_count_records, total_count_display_records = companies_for_user(params)

    {
      :iTotalRecords => total_count_records,
      :aaData => companies_aa_data(companies),
      :iTotalDisplayRecords => total_count_display_records,
      :sEcho => params[:sEcho]
    }.to_json.html_safe
  end

  private
    def companies_aa_data(companies)
      companies.collect do |company|

        # controls
        controlls = ""
        controlls << link_to("<i class='icon-pencil'></i>".html_safe, "#", { :class => 'edit_company', :"data-id" => company.id }) if can?(:update, company)
        controlls << "&nbsp;"
        controlls << link_to("<i class='icon-trash'></i>".html_safe, account_company_path(company.id),
                      :remote => true,
                      :method => :delete,
                      :confirm => t('account.companies.confirm_delete')
                     ) if can?(:delete, Company)

        controlls = "" if company.subdomain == Constant::MAIN_SUBDOMAIN

        [
          (image_tag(company.logo.wide.url, :style => "width: 150; height: 50px;") rescue ''),
          link_to(company.name, open_account_company_path(company), :remote => true),
          link_to(company.subdomain, company.subdomain_url, :target => "_blank"),
          controlls
        ]
      end
    end

    def companies_for_user(params)
      companies = current_user.companies_list.without_deleted

      total_count_records = companies.count

      # searching
      if companies.any? && params[:sSearch].present?
        companies = companies.where("companies.name LIKE '%%%s%%' OR companies.subdomain LIKE '%%%s%%'", params[:sSearch], params[:sSearch])
      end

      total_count_display_records = companies.count

      # pagination
      companies = companies.limit(params[:iDisplayLength].to_i).offset(params[:iDisplayStart].to_i) if companies.any?

      # sorting by columns
      if companies.any? && params[:iSortCol_0] && params["bSortable_#{ params[:iSortCol_0] }".to_sym]
        companies = companies.order("companies.#{ companies_display_columns[params[:iSortCol_0].to_i] } #{ params[:sSortDir_0] }")
      end

      [companies, total_count_records, total_count_display_records]
    end


    def companies_display_columns
      {
        0 => :logo,
        1 => :name,
        2 => :subdomain,
        3 => :actions
      }
    end
end
