class ClaimController < ApplicationController

  def index 
    @claims = current_account.requestee_claims.pending.joins(list_item: :list).where(list: { group_id: @selected_group.id })

    p "HERE~~"

    respond_to do |format|
      format.js { render 'index', locals: { requests: @claims }}
    end
  end

  def create
    @list_item = ListItem.find(params[:id])
  end

  def accept
    @claim = Claim.find(params[:id])

    # @claim.accept!

    if params[:is_last_claim] == 'true'
      flash.now[:notice] = "You've reviewed all the requests!"
    else
      flash.now[:notice] = "You accepted #{@claim.requester.first_name}'s request."
    end

    respond_to do |format|
      format.js { render 'accept', locals: { flash: flash } } 
    end
  end

  def deny 
    @claim = Claim.find(params[:id])

    # @claim.deny!

    if params[:is_last_claim] == 'true'
      flash.now[:notice] = "You've reviewed all the requests!"
    else
      flash.now[:notice] = "You denied #{@claim.requester.first_name}'s request."
    end

    respond_to do |format|
      format.js { render 'accept', locals: { flash: flash } } 
    end
  end
end
