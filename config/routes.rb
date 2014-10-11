Rails.application.routes.draw do

  resources :projects do
    resources :repositories, only: :pull do
      member do
        post :pull
      end
    end

    resources :containers, only: [:create, :destroy]
  end

  resources :images
end
