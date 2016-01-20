Rails.application.routes.draw do
  devise_for :users
  root to: "pdf#index"
end
