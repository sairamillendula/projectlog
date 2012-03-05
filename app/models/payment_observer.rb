class PaymentObserver < ActiveRecord::Observer
  
  def after_create(payment)
    invoice = payment.invoice
    total = payment.amount.round(2)
    
    tax1_rate = invoice.try(:tax1) || 0
    tax2_rate = invoice.try(:tax2) || 0
    compound = invoice.try(:compound) || false
    
    subtotal = total
    tax1 = 0
    tax2 = 0
    
    if tax2_rate > 0 and compound
      subtotal = (total / ((1 + (tax1_rate/100)) * (1 + (tax2_rate/100)))).round(2)
    else
      subtotal = (total / (1 + (tax1_rate/100) + (tax2_rate/100))).round(2)
    end
    
    if tax1_rate > 0
      tax1 = (subtotal * (tax1_rate/100)).round(2)
    end
      
    if tax2_rate > 0
      if compound
        tax2 = ((subtotal + tax1) * (tax2_rate/100)).round(2)
      else
        tax2 = (subtotal * (tax2_rate/100)).round(2)
      end
    end
    
    payment.invoice.user.transactions.create(
      :expense => false,
      :date    => payment.date,
      :note    => "Payment from #{payment.invoice.customer.name} (#{invoice.invoice_number})",
      :total   => total,
      :tax1    => tax1,
      :tax2    => tax2
    )
  end
end


