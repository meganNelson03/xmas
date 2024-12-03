class HomeController < ApplicationController
  skip_before_action :require_authentication

  def index
    if current_account.present?
      redirect_to lists_path
    end
  end

  def sign_up 
    sign_up_params = params[:sign_up]

    if sign_up_params.blank? || sign_up_params[:first_name].blank? || sign_up_params[:last_name].blank?
      redirect_to root_path, notice: "Bad"
      return
    end

    first_name, last_name = sign_up_params[:first_name], sign_up_params[:last_name]
    state = "#{first_name}_#{last_name}"

    repost(account_google_oauth2_omniauth_authorize_path(state: state, first_name: first_name, last_name: last_name), options: {authenticity_token: :auto})
  end

  private

  def person_params
    params.expect(sign_up: [:first_name, :last_name])
  end
end
