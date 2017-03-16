Rails.application.routes.draw do
  get 'welcome/index'

  devise_for :users
  resources :dictionaries, except: [:new, :create, :delete, :destroy] do
    resources :words
  end
  root 'welcome#index'
end
