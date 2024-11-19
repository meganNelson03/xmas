class ListItemController < ApplicationController
  before_action :set_list_item, only: [:show, :edit, :update, :destroy, :claim]
  before_action :verify_in_group, only: [:edit, :update, :destroy]

  def show 
    respond_to do |format|
      format.js { render 'show', locals: { list_item: @list_item }}
    end
  end

  def new
    list_item = ListItem.new 

    respond_to do |format|
      format.js { render 'new', locals: { list_item: list_item } }
    end
  end

  def create
    list_item = ListItem.new(list_item_params)

    respond_to do |format|
      if list_item.save
        format.js { render 'new', locals: { list_item: ListItem.new, success: true } }
      else
        format.js { render 'new', locals: { list_item: list_item } }
      end
    end
  end

  def edit    
    respond_to do |format|
      format.js { render 'edit', locals: { list_item: @list_item } }
    end
  end

  def update
    if @list_item.update(list_item_params)
      redirect_back fallback_location: lists_path
    end
  end

  def destroy
    @list_item.destroy!

    redirect_back fallback_location: lists_path
  end

  def claim
    if @list_item.claimed_by_id.present?
      @list_item.claimed_by_id = nil
    else
      @list_item.claimed_by_id = current_account.id
    end

    if @list_item.save
      @list_item.reload
    end

    @item_id = "item-#{@list_item.id}"

    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: lists_path, notice: "You've claimed a wish!" }
    end
  end

  private

  def set_list_item
    @list_item = ListItem.find(params[:id])
  end

  def verify_in_group
    if !@list_item.list.account.shares_group?(current_account)
      raise 'You are not allowed to update this item.'
    end
  end

  def list_item_params
    params.require(:list_item).permit(:description, :url, :price, :priority, :list_id)
  end
end