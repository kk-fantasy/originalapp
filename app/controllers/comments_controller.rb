class CommentsController < ApplicationController
    before_action :find_movie_and_review, only: [:new, :create]
  
    def new
      @comment = Comment.new
    end
  
    def create
      @comment = @review.comments.new(comment_params)
      @comment.user = current_user
  
      if @movie
        @comment.movie_id = @movie.id
      else
        flash[:danger] = '映画が見つかりませんでした。'
        redirect_to movies_path and return
      end
  
      if @comment.save
        redirect_to movie_review_path(@movie, @review), success: 'コメントが投稿されました。'
      else
        flash.now[:danger] = 'コメントの投稿に失敗しました。'
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def find_movie_and_review
      @movie = Movie.find_by(tmdb_id: params[:movie_tmdb_id])
      @review = Review.find(params[:review_id])  # review_id を使用して @review を取得する
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end