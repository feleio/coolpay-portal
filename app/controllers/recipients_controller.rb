class RecipientsController < ApplicationController
  def index
    if !session[:user_token]
      redirect_to '/login/index'
    end

    # get all recipients with coolpay api
    response = HTTParty.get("https://coolpay.herokuapp.com/api/recipients", 
      :headers => { 'Content-Type' => 'application/json',
                    'Authorization' => "Bearer #{session[:user_token]}" } )

    if response.code == 200
      result = JSON.parse(response.body, object_class: OpenStruct)
      @recipients = result.recipients
    elsif response.code == 401
      redirect_to '/login/index'
    end
  end

  def new
    if !session[:user_token]
      redirect_to '/login/index'
    end
  end

  def create
    if !session[:user_token]
      redirect_to '/login/index'
    end

    response = HTTParty.post("https://coolpay.herokuapp.com/api/recipients", 
      :body => { :recipient => {
                  :name => params[:name]
                } }.to_json,
      :headers => { 'Content-Type' => 'application/json',
                    'Authorization' => "Bearer #{session[:user_token]}" } )

    if response.code == 201
      redirect_to '/recipients/index'
    elsif response.code == 401
      redirect_to '/login/index'
    end
  end
end
