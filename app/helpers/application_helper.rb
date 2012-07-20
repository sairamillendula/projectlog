module ApplicationHelper
  def sortable(column, url_options = {}, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "sort #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil).merge(url_options), {:class => css_class}
  end

  # Creates a submit button with the given name with a cancel link
  # Accepts two arguments: Form object and the cancel link name
  def submit_or_cancel(form, name='Cancel')
    form.submit + " or " + link_to(name, 'javascript:history.go(-1);', :class => 'cancel')
  end

  # Markdown method
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(safe_links_only: true, hard_wrap: true)
    md = Redcarpet::Markdown.new(renderer, autolink: true, space_after_headers: true, no_intraemphasis: true)
    md.render(text).html_safe
  end

  def clear
    content_tag(:div, "", :class => "clear")
  end

  def currency_options
    options = []
    Money::Currency::TABLE.each_value do |cur|
      options << ["#{cur[:name]} (#{cur[:iso_code]})", cur[:iso_code]]
    end
    options
  end

  def contacts_options(customer)
    options = []
    customer.contacts.each do |c|
      options << ["#{c.first_name} #{c.last_name} - (#{c.email})", c.id]
    end
    options
  end

end
