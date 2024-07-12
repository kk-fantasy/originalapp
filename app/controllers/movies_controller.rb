class MoviesController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]

  def index
    # TMDbからホラー映画を取得
    tmdb_client = TmdbClient.new
    response = tmdb_client.fetch_horror_movies(1)  # 引数を追加
  
    if response.code == 200
      @tmdb_movies = response.parsed_response['results'].sample(15)
    else
      flash[:alert] = "映画の取得に失敗しました。"
      @tmdb_movies = []
    end

    # Ransackによる検索とタグフィルタリングの設定
    @q = Movie.ransack(params[:q])
    @movies = @q.result(distinct: true)

    # タグ検索の追加（タグIDでのフィルタリング）
    if params.dig(:q, :tag_id_eq).present?
      tag_id = params.dig(:q, :tag_id_eq)
      
      # タグでフィルタリングされたレビューを持つ映画を取得
      @movies = @movies.joins(reviews: :tags).where(reviews: { tags: { id: tag_id } }).distinct
    end

    # ページネーションを適用（常にActiveRecord::Relationであることを確認）
    @movies = @movies.page(params[:page]).per(15)

    # デバッグ用のログ出力
    Rails.logger.debug "検索結果: #{@movies.inspect}"
  end
  
  def show
    @movie = Movie.find_by(tmdb_id: params[:tmdb_id])

    if @movie.nil?
      # 映画がデータベースにない場合、TMDBから取得してデータベースに保存
      movie_data = fetch_movie_from_tmdb(params[:tmdb_id])
      if movie_data
        @movie = Movie.create!(
          title: movie_data['title'],
          description: movie_data['overview'], # TMDBの 'overview' を 'description' に保存
          release_date: movie_data['release_date'],
          poster_url: "https://image.tmdb.org/t/p/w500#{movie_data['poster_path']}",
          tmdb_id: movie_data['id']
        )
      else
        flash[:alert] = "指定された映画が見つかりませんでした。"
        return redirect_to movies_path
      end
    end

    @review = Review.new
    @overview = @movie.description.present? ? @movie.description : 'この映画のあらすじは公開されていません。' # `description` を参照
    @movie_reviews = @movie.reviews
  end

  private

  def fetch_movie_from_tmdb(movie_id)
    tmdb_client = TmdbClient.new
    movie_details = tmdb_client.fetch_movie(movie_id)
    movie_details if movie_details.present? && movie_details['status_code'].nil?  # エラーがなければ映画情報を返す
  end
end