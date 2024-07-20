class SearchController < ApplicationController
    def suggestions
      term = params[:term]
      suggestions = Movie.where('title LIKE ?', "%#{term}%").pluck(:title)
      render json: suggestions
    end
  end