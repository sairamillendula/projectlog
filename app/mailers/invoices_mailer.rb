class InvoicesMailer < ActionMailer::Base
  def invoice_by_email(invoice, user, contact, attach)
    @invoice = invoice
    if attach
      kit = PDFKit.new(attach)
      kit.to_file "#{Rails.root}/tmp/invoices/invoice#{@invoice.id}.pdf"
      attachments['invoice.pdf'] = File.read("#{Rails.root}/tmp/invoices/invoice#{@invoice.id}.pdf")
    end
    mail(:to => contact.email, :subject => "[Projectlog] Invoice for #{@invoice.subject} from #{user.profile.company}", :reply_to => user.email)
  end
end