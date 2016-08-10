class PaymentsController < ApplicationController  
  def index
    if !session[:user_token]
      redirect_to '/login/index'
    end


  end
end
