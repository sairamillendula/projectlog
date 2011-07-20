class Invoice < ActiveRecord::Base

belongs_to :user
belongs_to :customer

attr_accessible :issued_date, :due_date, :subject, :balance, :status, :note, :currency_id, :customer_id

def paid?
   status == "paid"
end

end
