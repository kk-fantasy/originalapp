class ReviewsController < ApplicationController
  before_action :set_movie, only: [:edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def new
    @movie = Movie.find_by(tmdb_id: params[:movie_tmdb_id])
    if @movie.nil?
      flash[:danger] = "映画が見つかりませんでした。"
      redirect_to movies_path
    else
      @review = Review.new
    end
  end

  def create
    @movie = Movie.find_by(tmdb_id: params[:movie_tmdb_id])
    if @movie.nil?
      flash[:danger] = "映画が見つかりませんでした。"
      redirect_to movies_path and return
    end
  
    @review = @movie.reviews.build(review_params)
    @review.user = current_user
    @review.tag_ids = params[:review][:tag_ids]
  
    if @review.save
      redirect_to movie_path(@movie.tmdb_id), success: 'レビューを投稿しました。'
    else
      render 'movies/show'
    end
  end

  def show
    @review = Review.find(params[:id])
    @movie = Movie.find(@review.movie_id)
  end

  def edit
    # @movie is already set by before_action
  end

  def update
    if @review.update(review_params)
      redirect_to movie_review_path(@movie.tmdb_id, @review), success: 'レビューが更新されました。'
    else
      flash.now[:danger] = 'レビューの更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to movie_path(@movie.tmdb_id), success: 'レビューが削除されました。'
  end

  private

  def set_movie
    @movie = Movie.find_by(tmdb_id: params[:movie_tmdb_id])
    if @movie.nil?
      redirect_to movies_path, danger: '映画が見つかりませんでした。'
    end
  end

  def set_review
    @review = Review.find(params[:id])
    @movie = Movie.find(@review.movie_id)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "指定されたレビューが見つかりませんでした。"
    redirect_to movies_path
    end
  end

  def review_params
    params.require(:review).permit(:title, :content, :rating, tag_ids: [])
  end
end