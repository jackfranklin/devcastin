require 'mail'
require 'dotenv'
Dotenv.load

Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                           :port      => 587,
                           :user_name => "jackfranklin",
                           :password  => ENV["SENDGRID_PASSWORD"],
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
end

module Devcasts
  class Mailer
    def initialize(dest, subject_text, content)
      @dest = dest
      @subject_text = subject_text
      @content = content

    end

    def send
      mail = Mail.new(
        from: 'Devcast.in <devcastin@gmail.com>',
        to: @dest,
        subject: @subject_text
      )

      html_part = Mail::Part.new(
        content_type: 'text/html; charset=UTF-8',
        body: @content
      )

      mail.html_part = html_part

      mail.deliver!
    end
  end
end

