class GroupController < ApplicationController

  def index 
    @group = current_account.groups.first
  end

  def group
    @group = Group.find(params[:id])
  end

  def my_groups
    @groups = current_account.groups
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
      redirect_to my_groups_path, notice: 'Yay!'
    end
  end

  private 

  def group_params
    params.require(:group).permit(
      :name
    )
  end
end
