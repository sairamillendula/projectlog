PDFKit.configure do |config|
  config.wkhtmltopdf = Rails.root.join('bin', 'wkhtmltopdf').to_s if Rails.env == 'production'
  config.default_options = {
  :print_media_type => true,
  :encoding => 'UTF-8'
  }
  #config.root_url = "http://localhost/" # Use only if your external hostname is unavailable on the server.
end
