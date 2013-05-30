class OmniauthCallbacksController < ApplicationController
  before_filter :basic_before_action

  def google
    # render :close, layout: false
    head :ok
  end

  private
  def basic_before_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      gmail
    end
  end

  def gmail
    email = @omniauth.info.email
    token = @omniauth.credentials.token
    gmail = Gmail.connect(:xoauth2, email, token)
    count = gmail.inbox.count

    mails =  gmail.inbox.emails(:unread).map do |mail| #options: :all,:read,:unread
      puts "Subject: #{mail.subject}"
      puts "Date: #{mail.date}"
      puts "From: #{mail.from}"
      puts "To: #{mail.to}"

      #process body
      if mail.text_part
        puts "text: " + mail.text_part.decoded
      elsif mail.html_part
        puts "html: " + mail.html_part.decoded
      else
        puts "body: " + mail.body.decoded.encode("UTF-8", mail.charset)
      end
    end

    binding.pry
  end
end
