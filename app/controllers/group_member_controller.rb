class GroupMemberController < ApplicationController

  def index 
    @group = current_account.groups.find(params[:id])

    respond_to do |format|
      format.js { render 'show_group', locals: { group: @group} }
    end
  end

  def new
    respond_to do |format|
      format.js { render 'new' }
    end
  end

  def create
    account = Account.find_by(id: params[:account_id])
    group = Group.find(params[:id])

    if account.present? 
      if !account.in_group?(group)
        account.accounts_groups.create(group_id: group.id)
      end
    end

    redirect_to my_groups_path(group_id: group.id), notice: 'You added a new group member.'
  end

  def invite 
    account = Account.find_by(email: params[:email])

    if account.blank?
      new_account = Account.new(email: params[:email])
      if new_account.save!
        new_account.invite!
        new_account.accounts_groups.create(group_id: params[:id])
      end
    end

    redirect_to my_groups_path(group_id: params[:id]), notice: "You've invited #{params[:email]} to your group!"
  end
end
