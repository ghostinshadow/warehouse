Rails.application.routes.draw do
  get 'structure_elements/new'

  get 'shippings/index'

  get 'shippings/new'

  get 'shippings/edit'

  get 'welcome/index'

  devise_for :users
  resources :dictionaries, except: [:new, :create, :delete, :destroy] do
    resources :words do
      member do
        get :subtypes
      end
    end
  end
  resources :shippings
  resources :resources
  root 'welcome#index'
end
