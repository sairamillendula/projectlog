module ProfilesHelper
  
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
end
