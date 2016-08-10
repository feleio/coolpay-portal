Rails.application.routes.draw do
  get 'main/index'

  get 'login/index'

  post 'login/login'

  get 'login/logout'

  get 'recipients/index'

  get 'recipients/new'

  post 'recipients/create'

  get 'payments/index'
  
  get 'payments/new'
  
  post 'payments/create'

  root 'recipients#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
