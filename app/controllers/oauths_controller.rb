class OauthsController < ApplicationController
    skip_before_action :require_login, only: [:oauth, :callback]
    protect_from_forgery except: :callback
  
    def oauth
      provider = params[:provider]
      if provider == 'google' || provider == 'google_oauth2'
        redirect_to "https://accounts.google.com/o/oauth2/auth?client_id=#{ENV['GOOGLE_CLIENT_ID']}&redirect_uri=#{ENV['GOOGLE_CALLBACK_URL']}&response_type=code&scope=email profile", allow_other_host: true
      else
        render plain: "Provider #{provider} is not supported"
      end
    end
  
    def callback
      provider = params[:provider]
      if provider == 'google' || provider == 'google_oauth2'
        user = User.from_omniauth(request.env["omniauth.auth"])
        if user.persisted?
          auto_login(user)
          redirect_to root_path, success: "Google認証に成功しました"
        else
          session["devise.google_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url, alert: "Google認証に失敗しました"
        end
      else
        render plain: "Provider #{provider} is not supported"
      end
    end
  end