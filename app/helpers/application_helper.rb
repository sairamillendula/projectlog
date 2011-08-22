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
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis]
    Redcarpet.new(text, *options).to_html.html_safe
  end
  
  def clear
    content_tag(:div, "", :class => "clear")
  end
end
