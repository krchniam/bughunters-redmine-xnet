module ChartsHelper

  def self.l(s)
    s
  end

  # Shows chart plugin menu.
  def show_charts_menu(separator = ' | ')
    res = ""
    RedmineCharts::Utils.controllers_for_routing do |name, controller_name|      
      link_name = l("charts_link_#{name}".to_sym)

      if controller.controller_name == controller_name
        res << separator << link_name
      else
        res << separator << link_to(link_name, :controller => controller_name)
      end
    end
    res
  end

  # Shows chart flash setting path to data.
  def show_graph
    url_for_data = url_for(controller.params.merge(:action => :data)).gsub('&amp;', '&')
    relative_url_path = ActionController::Base.respond_to?(:relative_url_root) ? ActionController::Base.relative_url_root : ActionController::AbstractRequest.relative_url_root
    html, div_name = controller.open_flash_chart_object_and_div_name('100%', '400', url_for_data, true, "#{relative_url_path}/")

    html << '<script type="text/javascript">' << "\n"
    html << "var charts_to_image_title = '#{h(controller.title)}';\n" 
    html << "var charts_to_image_id = '#{div_name}';\n"
    html << '</script>'

    html
  end

  # Shows date condition.
  def show_date_condition(range_steps, range_in, range_offset)
    res = l(:charts_show_last) << " "
    res << text_field_tag(:range_steps, range_steps, :size => 4)
    res << hidden_field_tag(:range_offset, range_offset) << " "
    res << select_tag(:range_in, options_for_select(RedmineCharts::RangeUtils.in_options, range_in.to_s))

    res << '<br/><br/>'

    # Pagination.

    res << link_to_function(l(:charts_earlier), :onclick => 'charts_earlier();') << " - "

    if range_offset.to_i == 1
      res << l(:charts_later)
    else
      res << link_to_function(l(:charts_later), :onclick => 'charts_later();')
    end

    res
  end

  # Shows pages.
  def show_pages(page, pages)
    if pages > 1
      if page == 1
        res = l(:charts_previous)
      else
        res = link_to_function(l(:charts_previous), :onclick => 'charts_previous();')
      end

      res << ' - '

      if page == pages
        res << l(:charts_next)
      else
        res << link_to_function(l(:charts_next), :onclick => 'charts_next();')
      end

      res
    end
  end

end
