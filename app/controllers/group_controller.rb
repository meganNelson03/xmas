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
      @group = @groups.find_by(id: params[:group_id])
    else
      @group = @selected_group
    end

    respond_to do |format|
      format.js { render 'group_member/show_group', locals: { group: @group }}
      format.html
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
    group.administrator = current_account

    if group.save 
      group.accounts_groups.create(account_id: current_account.id)
      redirect_to my_groups_path(group_id: group.id), notice: 'Yay! You made a group.'
    else 
      redirect_to my_groups_path, notice: 'Something went wrong.'
    end
  end

  def edit
    @group = Group.find(params[:id])

    respond_to do |format|
      format.js { render 'edit', locals: { group: @group } }
    end
  end

  def destroy 
    @group = Group.find(params[:id])

    if current_account != group.administrator
      redirect_to my_groups_path, notice: "You're not allowed to delete this group." and return 
    end

    if @group.destroy 
      redirect_to my_groups_path, notice: "Hope you're happy with yourself. The group is gone forever."
    else 
      redirect_to my_groups_path, notice: 'Something went wrong. Please try again later.'
    end
  end

  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update(group_params)
        format.js { render js: "window.location.replace('#{request.env["HTTP_REFERER"]}');" }
      else 
        format.js { render 'edit', locals: { group: @group } }
      end
    end
  end

  def request_to_join
    group = Group.find(params[:id])

    current_account.membership_requests.create(group_id: group.id)

    redirect_to my_groups_path, notice: "You've requested to join a group! Check back later."
  end

  def switch
    group = current_account.groups.find(params[:id])

    current_account.current_group_id = group.id
    current_account.save!

    redirect_back fallback_location: lists_path, notice: "You've switched to #{group.name}."
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

    if params[:email].present? 
      groups = (groups.presence || Group).joins(:accounts).where('accounts.email ILIKE ?', "%#{params[:email]}%")
    end

    if groups.present?
      groups = groups.left_joins(:accounts).where.not(accounts: { id: current_account.id }) 
    end

    return groups&.distinct
  end 
end
