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
    imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
    imap.authenticate('XOAUTH2', email, token)
    messages_count = imap.status('INBOX', ['MESSAGES'])['MESSAGES']
    binding.pry
  end
end
