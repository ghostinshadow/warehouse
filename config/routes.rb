Rails.application.routes.draw do
  get 'welcome/index'

  devise_for :users
  resources :units
  root 'welcome#index'
end
