class GroupController < ApplicationController

  def index 
    @group = current_account.groups.first
  end

  def group
    @group = Group.find(params[:id])
  end

  def my_groups
    @groups = current_account.groups

    if params[:group_id].present? 
      @group = Group.find_by(id: params[:group_id])
    else
      @group = @groups.first 
    end
  end

  def new_search 
    respond_to do |format|
      format.js { render 'new_search' }
    end
  end

  def search
    @groups = filter_groups(params[:search])

    respond_to do |format|
      format.js { render 'search', locals: { groups: @groups } }
    end
  end

  def new
    @group = Group.new

    respond_to do |format|
      format.js { render 'new', locals: { group: @group } }
    end
  end

  def create 
    group = Group.new(group_params)

    if group.save 
      group.accounts_groups.create(account_id: current_account.id)
      redirect_to my_groups_path(group_id: group.id), notice: 'Yay! You made a group.'
    end
  end

  def request_to_join
    group = Group.find(params[:id])

    current_account.membership_requests.create(group_id: group.id)

    redirect_to my_groups_path, notice: "You've requested to join a group! Check back later."
  end

  private 

  def group_params
    params.require(:group).permit(
      :name
    )
  end

  def filter_groups(params)
    return (groups = Group.none) if params.blank? 

    if params[:name].present?
      groups = Group.where('name ILIKE ?', "%#{params[:name]}%") 
    end

    p "!!!"
    p groups

    if params[:email].present? 
      groups = (groups.presence || Group).joins(:accounts).where('accounts.email ILIKE ?', "%#{params[:email]}%")
    end

    if groups.present?
      groups = groups.left_joins(:accounts).where.not(accounts: { id: current_account.id }) 
    end

    return groups&.distinct
  end 
end
