class InvoicesMailer < ActionMailer::Base
  def invoice_by_email(invoice, subject, body, user, recipients, attach)
    @invoice = invoice
    @bodytext = body
    if attach
      kit = PDFKit.new(attach)
      attachments['invoice.pdf'] = kit.to_pdf
    end
    mail(:from => "#{user.name} <notifications@projectlogapp.com>", :to => recipients, :subject => subject, :reply_to => user.email)
  end
end