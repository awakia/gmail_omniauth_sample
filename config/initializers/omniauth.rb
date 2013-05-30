Rails.application.config.middleware.use OmniAuth::Builder do
  OAUTH_CONFIG = YAML.load_file("#{Rails.root}/config/omniauth.yml")[Rails.env].symbolize_keys!

  provider :google_oauth2, OAUTH_CONFIG[:google]['key'], OAUTH_CONFIG[:google]['secret'], name: :google,
    scope: ['https://www.googleapis.com/auth/userinfo.email',
            'https://www.googleapis.com/auth/userinfo.profile',
            #'https://www.googleapis.com/auth/plus.me',
            #'https://www.google.com/m8/feeds',
            'https://mail.google.com/'].join(' ')
end
