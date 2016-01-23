Rails.application.routes.draw do
  devise_for :users
  resources :reports do
    get :generate_pdf, on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :reports, only: [:index, :show]
    end
  end

  root to: "reports#index"
end
