class GroupMemberController < ApplicationController

  def index 
    @group = current_account.groups.find(params[:id])
  end

  def new
    respond_to do |format|
      format.js { render 'new' }
    end
  end

  def create
    account = Account.find(params[:id])

    if current_account.grouped? 
      account.update(group_id: current_account.group_id)
    else
      group = Group.create 
      current_account.update(group_id: group.id)
      account.update(group_id: group.id) 
    end

    redirect_to group_path
  end

  def merge
    account = Account.find(params[:id])

    if current_account.grouped? && !current_account.shares_group?(account)
      account.group.accounts.update_all(group_id: current_account.group.id) 
    elsif account.group.present? 
      current_account.update(group_id: account.group.id) 
    end

    respond_to do |format|
      format.js { render 'success', locals: { account: account, message: "Yay! #{account.first_name} is in your group." } }
    end
  end
end
