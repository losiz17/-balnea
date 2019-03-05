Rails.application.routes.draw do
  resources :samples
  get 'onsen_search/:onsen_q/:pref/:id/new/:oid',      to: 'samples#new'    # 新しい投稿のフォームを表示する
  get 'hotel/:id',      to: 'hotel#index'    # ホテル・宿一覧
  get 'onsen_search/:onsen_q/:pref',      to: 'onsen_search#index'    # 検索結果一覧
  get 'onsen_search/:onsen_q/:pref/:id',  to: 'onsen_search#show'    # 詳細
  root 'top#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
