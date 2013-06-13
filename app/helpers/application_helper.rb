module ApplicationHelper

  def get_page_count(count, per_page)
    page_count = count.divmod(per_page)[0]
    if count.divmod(per_page)[1] > 0
      page_count = page_count + 1
    end
  end
  
  #date picker
  def form_date(str)
    return "" if str.blank? || str.nil?
    date = str.split("/")

    if date.length == 3
      return "#{date[1]}/#{date[0]}/#{date[2]}".to_date
    else
      return str.to_date
    end
  end

  def iloader(name, show="hide")
    raw("<span id=\"#{name}\" class=\" #{show}\">Loading...<i class=\"icon-spinner icon-spin \"></i></span>")
  end

  def loader(name, show="hide")
    raw("<i id=\"#{name}\" class=\"icon-spinner icon-spin #{show} \"></i>")
  end
  
  def span_loader(name, show='hide', options = {})
    html = "<span style=\"position: relative; margin-left: 0; \" class=\"ajax_loader #{show}\" id=\"#{name}\">"
    html += image_tag("loading-small.gif")
    html += "</span>"
    return raw(html)
  end  

  def page_title
    "#{@page_title}"
  end

  def show_current_lang
    case session[:lang].to_s
    when "en"
      return "flag-us"
    when "ja"
      return "flag-jp"
    else
      return "flag-us"
    end 
  end

end
