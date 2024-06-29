class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    Rails.logger.debug("Params: #{params}")
    Rails.logger.debug("User: #{@user}")

    if @user
      session[:user_id] = @user.id # セッションにユーザーIDを保存
      Rails.logger.debug("セッションに保存されたユーザーID: #{session[:user_id]}")
      redirect_to root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    Rails.logger.debug("ログアウト後のセッション: #{session.to_hash}")
    redirect_to root_path, status: :see_other, success: 'ログアウトしました '
  end
end
