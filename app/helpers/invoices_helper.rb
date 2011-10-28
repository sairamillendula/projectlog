module InvoicesHelper

  def calc_line f
    line = f.object
    user = line.invoice && line.invoice.user || current_user
    profile = user.profile
    subtotal = ((line.quantity || 0) * (line.price || 0)).round 2
    taxes = 0
    html = ""
    cur_tax = if line.tax1.blank?
                if line.tax2.blank? then
                  0
                else
                  2
                end
              else
                if line.tax2.blank? then
                  1
                else
                  3
                end
              end
    if profile.any_taxes?
      html << "<div class=\"td item-subtotal\">#{subtotal}</div>"
      html << "<div class=\"td\">"
      html << select_tag(:taxes, options_for_select(profile.tax_options, cur_tax), :class => "item-select-tax")
      html << "</div>"
      unless profile.tax1.blank?
        html << "<div class=\"td\">"
        unless line.tax1.blank?
          val = (subtotal * profile.tax1 / 100).round 2
          taxes += val
        else
          val = ""
        end
        html << f.text_field(:tax1, :value => val, :readonly => true, :class => "label_field", :size => 5)
        html << "</div>"
      end
      unless profile.tax2.blank?
        html << "<div class=\"td\">"
        unless line.tax2.blank?
          if profile.compound
            val = ((subtotal + taxes) * profile.tax2 / 100).round 2
          else
            val = (subtotal * profile.tax2 / 100).round 2
          end
          taxes += val
        else
          val = ""
        end
        html << f.text_field(:tax2, :value => val, :readonly => true, :class => "label_field", :size => 5)
        html << "</div>"
      end
    end
    html << "<div class=\"td item-total\">"
    html << f.text_field(:line_total, :value => (subtotal + taxes).round(2), :readonly => true, :class => "label_field", :size => 5)
    html << "</div>"
    html
  end

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
