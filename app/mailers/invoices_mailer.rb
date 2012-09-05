class InvoicesMailer < ActionMailer::Base
  layout "email/notification"
  
  def invoice_by_email(invoice, subject, body, user, recipients, attach)
    @invoice = invoice
    @bodytext = body
    if attach
      kit = PDFKit.new(attach)
      attachments["Invoice #{invoice.invoice_number}.pdf"] = kit.to_pdf
    end
    mail(:from => "#{user.name} <notifications@projectlogapp.com>", :to => recipients, :subject => subject, :reply_to => user.email)
  end

  def send_reminder_when_late(invoice)
    @invoice = invoice
    mail(from: "Projectlog <notifications@projectlogapp.com>", subject: "Reminder: Invoice late", 
         to: "#{@invoice.user.full_name} <#{@invoice.user.email}>" )
  end
end