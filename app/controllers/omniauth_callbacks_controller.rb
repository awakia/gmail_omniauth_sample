require 'nkf'

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

    mails =  gmail.inbox.emails(:all).map do |mail| #options: :all,:read,:unread
      email = Email.new
      email.from = mail_address(mail.from)
      email.to = mail_address(mail.to)
      email.subject = NKF::nkf('-wm', mail.subject)  # MIME decoding
      email.date = mail.date
      email.message_id = mail.message_id
      email.in_reply_to = mail.in_reply_to
      email.content_type = mail.content_type
      email.charset = mail.charset
      email.references = mail.references.to_s
      email.header = mail.header.to_s

      #process body
      if mail.text_part
        body = mail.text_part.decoded
      elsif mail.html_part
        body = mail.html_part.decoded
      else
        body = mail.body.decoded.encode("UTF-8", mail.charset)
      end

      email.save!
    end

    binding.pry
  end

  def mail_address(adr)
    if adr.is_a? Array
      adr.map{ |x| mail_address(x) }.join(', ')
    elsif adr.is_a? Net::IMAP::Address
      res = ''
      res += '"' + adr.name + '" ' if adr.name
      res += "<#{adr.mailbox}@#{adr.host}>"
    else
      res.to_s
    end
  end
end
