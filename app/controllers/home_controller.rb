class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index, :top]
    def index
      @random_reviews = Review.order(Arel.sql('RANDOM()')).limit(5)
    end

    def top; end
  end
  