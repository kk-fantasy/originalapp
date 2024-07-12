class TmdbClient
  include HTTParty
  base_uri 'https://api.themoviedb.org/3'

  def initialize
    @api_key = ENV['TMDB_API_KEY']
  end

  # ホラー映画一覧を取得するメソッド
  def fetch_horror_movies(page = 1)
    options = {
      query: {
        api_key: @api_key,
        with_genres: '27',  # ホラー映画ジャンルID
        sort_by: 'popularity.desc',  # 人気順でソート
        language: 'ja',  # 日本語のデータ
        page: page  # ページ番号を追加
      }
    }
    self.class.get("/discover/movie", options)
  end

  # 特定の映画の詳細を取得するメソッド
  def fetch_movie(movie_id)
    options = {
      query: {
        api_key: @api_key,
        language: 'ja'  # 日本語のデータ
      }
    }
    response = self.class.get("/movie/#{movie_id}", options)
    response.parsed_response  # 取得したレスポンスをパースして返す
  end
end