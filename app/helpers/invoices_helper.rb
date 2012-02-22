module InvoicesHelper
  
  def get_company_info p
    html = ""
    html << "<strong>#{p.company}</strong><br />" unless p.company.blank?
    html << p.address1 << "<br />" unless p.address1.blank?
    html << p.address2 << "<br />" unless p.address2.blank?
    html << p.city << ", " unless p.city.blank?
    html << p.province << " " unless p.province.blank?
    html << p.postal_code unless p.postal_code.blank?
    html << "<br />" unless p.city.blank? && p.province.blank? && p.postal_code.blank?
    html << p.country << "<br />" unless p.country.blank?
    html << p.phone_number << "<br />" unless p.phone_number.blank?
    html.html_safe
  end
  
  def get_customer_info c
    html = ""
    html << "<strong>#{c.name}</strong><br />" unless c.name.blank?
    html << c.address1 << "<br />" unless c.address1.blank?
    html << c.address2 << "<br />" unless c.address2.blank?
    html << c.city << ", " unless c.city.blank?
    html << c.province << " " unless c.province.blank?
    html << c.postal_code unless c.postal_code.blank?
    html << "<br />" unless c.city.blank? && c.province.blank? && c.postal_code.blank?
    html << c.country << "<br />" unless c.country.blank?
    html << c.phone << "<br />" unless c.phone.blank?
    html.html_safe
  end
end
