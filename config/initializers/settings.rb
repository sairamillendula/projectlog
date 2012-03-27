Settings.defaults['reports.email.subject'] = "Hello there, I want to share a report with you!"
Settings.defaults['reports.email.body'] = 
"Hello,

Click the following link to see the report: %{report_link}

Bye!"

Settings.defaults['invoices.email.subject'] = "Invoice for %{invoice_subject} from %{user_company}"
Settings.defaults['invoices.email.body'] = "Hello,

I wish to submit an invoice for our project.
Click the following link to see the invoice in your browser: %{invoice_link}

Bye!"

Settings.defaults['subscriptions.trial_period'] = 30
Settings.defaults['subscriptions.max_failed_payments'] = 3
Settings.defaults['subscriptions.auto_bill_outstanding'] = false
Settings.defaults['subscriptions.default_costing_plan_id'] = 2

Settings.defaults['subscription_receipt_signature'] = "
Projectlog
65 Blvd Fournier
Gatineau, QC, J8X3P6 
Canada

contact@getprojectlog.com
http://getprojectlog.com

Thank you for subscribing!"