class PaymentsController < ApplicationController  
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
      result.recipients
      
      @recipients_names = Hash.new
      result.recipients.each do |recipient|
        @recipients_names[recipient.id] = recipient.name
      end

      responsePayments = HTTParty.get("https://coolpay.herokuapp.com/api/payments", 
      :headers => { 'Content-Type' => 'application/json',
                    'Authorization' => "Bearer #{session[:user_token]}" } )

      if responsePayments.code == 200
        result = JSON.parse(responsePayments.body, object_class: OpenStruct)
        @payments = result.payments
        @balance = 0
        @payments.each do |payment|
          if payment.status == 'paid'
            @balance = @balance + payment.amount.to_f
          end
        end
        @balance = @balance * -1
      elsif responsePayments.code == 401
        redirect_to '/login/index'
      end

    elsif response.code == 401
      redirect_to '/login/index'
    end
  end

  def new
    if !session[:user_token]
      redirect_to '/login/index'
    end

    @recipient_name = params[:recipient_name]
    @recipient_id = params[:recipient_id]
  end

  def create
    if !session[:user_token]
      redirect_to '/login/index'
    end

    response = HTTParty.post("https://coolpay.herokuapp.com/api/payments", 
      :body => { :payment => {
                  :amount => params[:amount],
                  :currency => 'GBP',
                  :recipient_id => params[:recipient_id]
                } }.to_json,
      :headers => { 'Content-Type' => 'application/json',
                    'Authorization' => "Bearer #{session[:user_token]}" } )

    if response.code == 201
      redirect_to '/payments/index'
    elsif response.code == 401
      redirect_to '/login/index'
    end
  end
end
