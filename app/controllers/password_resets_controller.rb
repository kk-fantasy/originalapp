class PasswordResetsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :edit, :update]

    def new
    end
  
    def create
      @user = User.find_by(email: params[:email])
      if @user
        @user.reset_password_instructions!
        redirect_to login_path, success: 'パスワードリセット手順を送信しました'
      else
        flash.now[:danger] = '該当するメールアドレスのユーザーが見つかりませんでした'
        render :new
      end
    end
  
    def edit
      @token = params[:token]
      @user = User.load_from_reset_password_token(@token)
  
      if @user.blank?
        not_authenticated
        return
      end
    end
  
    def update
      @token = params[:token]
      @user = User.load_from_reset_password_token(@token)
  
      if @user.blank?
        not_authenticated
        return
      end
  
      # パスワードと確認用パスワードの検証と更新処理
      if params[:user][:password].present? && params[:user][:password_confirmation].present?
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
  
        if @user.save
          redirect_to login_path, success: 'パスワードを変更しました'
        else
          flash.now[:danger] = 'パスワードの変更に失敗しました。再度お試しください。'
          render :edit
        end
      else
        flash.now[:danger] = 'パスワードと確認用パスワードを入力してください'
        render :edit
      end
    end
  end