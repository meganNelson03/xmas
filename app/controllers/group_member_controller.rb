class GroupMemberController < ApplicationController

  def new
    respond_to do |format|
      format.js { render 'new' }
    end
  end

  def create
    account = Account.find(params[:id])

    if current_account.grouped? 
      account.update(account_group_id: current_account.account_group_id)
    else
      group = AccountGroup.create 
      current_account.update(account_group_id: group.id)
      account.update(account_group_id: group.id) 
    end

    redirect_to my_group_path
  end

  def merge
    account = Account.find(params[:id])

    if current_account.grouped? && !current_account.shares_group?(account)
      account.account_group.accounts.update_all(account_group_id: current_account.account_group.id) 
    elsif account.account_group.present? 
      current_account.update(account_group_id: account.account_group.id) 
    end

    respond_to do |format|
      format.js { render 'success', locals: { account: account, message: "Yay! #{account.first_name} is in your group." } }
    end
  end
end