# config/initializers/session_store.rb

Rails.application.config.session_store :cookie_store, key: '_myapp_session', expire_after: 14.days, secure: Rails.env.production?

# セッションストアの種類:
# - :cookie_store: セッションをクッキーに保存します（デフォルト）。
# - :cache_store: セッションをキャッシュに保存します。
# - :mem_cache_store: セッションをメモリキャッシュに保存します。
# - :active_record_store: セッションをデータベースに保存します（追加のgemが必要です）。

# key: セッションクッキーの名前。デフォルトは '_myapp_session' です。

# expire_after: セッションの有効期限。デフォルトではセッションクッキーがブラウザのセッション終了時に破棄されます。
# 例: expire_after: 14.days

# secure: true の場合、セッションクッキーは HTTPS 経由でのみ送信されます。通常、これは production 環境で有効にします。