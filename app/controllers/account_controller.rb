class AccountController < ApplicationController
  def search
    accounts = Account.where(email: params[:search][:email])
    group = Group.find(params[:id])

    respond_to do |format|
      format.js { render 'search', locals: { results: accounts, group: group, email: params[:search][:email] } }
    end
  end
end
