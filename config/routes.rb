Rails.application.routes.draw do
  root 'home#index'
  get 'privacy/show'
  get 'terms/show'
  get 'terms', to: 'terms#show', as: 'terms'
  get 'privacy', to: 'privacy#show', as: 'privacy'

  # ユーザー認証
  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  # マイページ
  get '/my_page', to: 'users#show', as: 'my_page'

  # 映画とレビュー
  resources :movies, param: :tmdb_id, only: [:index, :show] do
    resources :reviews, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      resources :comments, only: [:new, :create], param: :review_id
    end
  end

  # パスワードリセット機能のルート
  resources :password_resets, only: [:new, :create, :edit, :update], param: :token
  
  # LetterOpenerWeb
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # 不要なレビューのルートを削除
  # get 'reviews/new'
  # get 'reviews/create'
end

