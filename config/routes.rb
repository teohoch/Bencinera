Rails.application.routes.draw do
  get 'home/show'
  root to: 'home#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
