class ApplicationController < ActionController::Base
  # allow_browser versions: :modern

  before_action :set_current_account
  before_action :require_authentication

  def set_current_account
    @current_account = current_account
  end

  def require_authentication
    if current_account.blank?
      redirect_to home_path and return
    end
  end
end
