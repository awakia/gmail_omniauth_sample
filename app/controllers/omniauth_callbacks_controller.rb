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
      binding.pry
    end
  end

  def gmail
    email = @omniauth.info.email
    token = @omniauth.credentials.token
    gmail = Gmail.connect(:xoauth, "email@domain.com",
      :token           => 'TOKEN',
      :secret          => 'TOKEN_SECRET',
      :consumer_key    => 'CONSUMER_KEY',
      :consumer_secret => 'CONSUMER_SECRET'
    )
  end
end
