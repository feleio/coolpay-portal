class LoginController < ApplicationController
  def index
    @login_failed = false
  end

  def login
    response = HTTParty.post("https://coolpay.herokuapp.com/api/login", 
      :body => { :username => params[:username], 
                 :apikey => params[:key]
               }.to_json,
      :headers => { 'Content-Type' => 'application/json' } )

    if response.code == 200
      result = JSON.parse(response.body, object_class: OpenStruct)
      session[:user_token] = result.token
      redirect_to '/'
    else
      @login_failed = true
      render 'login/index'
    end
  end
end
