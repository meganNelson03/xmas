class ApplicationController < ActionController::Base
  # allow_browser versions: :modern

  before_action :set_current_account
  before_action :set_group_context
  before_action :require_authentication

  def set_current_account
    @current_account = current_account
  end

  def require_authentication
    if current_account.blank?
      redirect_to home_path and return
    end
  end

  def set_group_context 
    return if current_account.groups.blank? 

    if current_account.current_group.present? 
      @selected_group = current_account.current_group
    else 
      @selected_group = current_account.groups.first
      current_account.update(current_group_id: @selected_group.id)
    end
  end
end
