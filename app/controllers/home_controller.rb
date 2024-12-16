class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index, :top]
    def index
      Rails.logger.debug("現在のセッション: #{session.to_hash}")
      @random_reviews = Review.order(Arel.sql('RANDOM()')).limit(5)
    end

    def top; end
  end
  