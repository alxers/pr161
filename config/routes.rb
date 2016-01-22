Rails.application.routes.draw do
  devise_for :users
  resources :reports do
    get :generate_pdf, on: :member
  end
  root to: "reports#index"
end
