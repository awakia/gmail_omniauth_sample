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
    binding.pry
  end
end
