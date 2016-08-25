class CurrenciesController < ApplicationController
  
  def change_currency
    if request.xhr?
      session[:currency_code] = params[:currency_code]
      session[:rate] = session[:currency_code] != 'JPY' ? Currency.get_rate(session[:currency_code]) : 0
      session[:latest_rate_get_time] = Time.current
      return render text: 'success'
    end
  end
end
