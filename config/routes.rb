Rails.application.routes.draw do
  # ログイン画面
  get 'login', to: 'login#index'
  # ログイン処理
  post 'login/search', to: 'login#search'
  # ホーム画面
  get 'home', to: 'home#index'
  # ログアウト
  get 'logout', to: 'logout#index'
  # サインアップ
  get 'sign_up', to: 'sign_up#index'
  # 個別企業情報
  get 'client', to: 'client_info#index'
  # CSVインポート画面
  get 'csv/import', to: 'csv_import#index'
  # CSVインポート処理
  post 'csv/import/execute', to: 'csv_import#import'
  # CSVエクスポート画面
  get 'csv/export', to: 'csv_export#index'
  # CSVエクスポート画面
  post 'csv/export/execute', to: 'csv_export#export'
  # CSVエクスポート画面クライアント仕訳情報取得可能範囲取得
  get 'csv/export/getPeriod', to: 'csv_export#get_period'

  # 案件対応一覧
  get 'issue', to: 'issue#index'
  # 個別企業情報 モーダル「確認した」ボタン押下
  post 'client/message_confirm', to: 'client_info#message_confirm'
  # クエリ設定画面
  get 'setting', to: 'setting#index'
  # メッセージ登録処理
  get 'setting/registration', to: 'setting#registration'
  # サジェストメッセージ画面表示
  get 'suggestion', to: 'suggest_message#index'
end
