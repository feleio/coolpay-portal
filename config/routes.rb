Rails.application.routes.draw do
  get 'main/index'

  get 'login/index'

  post 'login/login'

  get 'recipients/index'

  get 'payments/index'

  root 'recipients#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
