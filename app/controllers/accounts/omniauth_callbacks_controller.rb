class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :require_authentication
  skip_before_action :verify_authenticity_token
  
  def google_oauth2
    account = Account.from_google(from_google_params)
    params = format_params(params, auth)

    if account.present?
      sign_out_all_scopes

      if account.first_name.blank?
        account.update(first_name: params[:first_name])
      end 

      if account.last_name.blank?
        account.update(last_name: params[:last_name])
      end

      flash[:notice] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect account, event: :authentication
    else
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path
    end
   end

   def from_google_params
     @from_google_params ||= {
       uid: auth.uid,
       email: auth.info.email
     }
   end

   def auth
     @auth ||= request.env['omniauth.auth']
   end

   def format_params(params, auth) 
    return if auth.blank?
    params = {}
    params.merge(first_name: auth.info.first_name, last_name: auth.info.last_name)
   end
end
