require 'sidekiq/web'
Rails.application.routes.draw do

  post :process, to: 'home#process_push'

  get :console, to: 'home#console'

  get 'suite/:id', to: 'home#suite', as: :suite

  # get 'classes/:html', to: 'home#renderer'
  # get 'packeges/:html', to: 'home#renderer'
  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'
end
