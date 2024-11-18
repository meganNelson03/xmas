class AccountController < ApplicationController
  def search
    accounts = Account.where(email: params[:search][:email])

    respond_to do |format|
      format.js { render 'search', locals: { results: accounts } }
    end
  end
end