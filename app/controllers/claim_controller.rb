class ClaimController < ApplicationController

  def index 
    @claims = current_account.requestee_claims.pending.joins(list_item: :list).where(list: { group_id: @selected_group.id })

    respond_to do |format|
      format.js { render 'index', locals: { requests: @claims }}
    end
  end

  def create
    @list_item = ListItem.find(params[:id])

    @claim = Claim.new(
      list_item_id: @list_item.id,
      requester_id: current_account.id,
      requestee_id: @list_item.claimed_by_id
    )
   
    if @claim.save
      flash.now[:notice] = "You asked to share this wish!"
      
      respond_to do |format|
        format.js { render 'request', locals: { claim: @claim, flash: flash } }
      end
    else 
      render_error("Something went wrong.") and return
    end    
  end

  def destroy
    @claim = Claim.find(params[:id])

    if @claim.destroy 
      redirect_back fallback_location: lists_path, notice: "You've rescinded your request to share a wish."
    else 
      render_error("Something went wrong.")
    end
  end

  def toggle 
    @claim = Claim.find(params[:id])

    if !['accepted', 'revoked'].include?(@claim.status) || @claim.requester != current_account
      render_error("You aren't allowed to update this claim.") and return
    end

    if @claim.accepted? 
      @claim.revoke!
    elsif @claim.revoked?
      @claim.reinstate! 
    end

    respond_to do |format|
      format.js { render 'toggle', locals: { claim: @claim, list_item: @claim.list_item }}
    end
  end

  def accept
    @claim = Claim.find(params[:id])

    if !@claim.pending? || @claim.requestee != current_account
      render_error("You can't accept this claim.") and return
    end

    @claim.accept!

    if params[:is_last_claim] == 'true'
      flash.now[:notice] = "You've reviewed all the requests!"
    else
      flash.now[:notice] = "You accepted #{@claim.requester.first_name}'s request."
    end

    respond_to do |format|
      format.js { render 'accept', locals: { flash: flash, last: params[:is_last_claim] == 'true' } } 
    end
  end

  def deny 
    @claim = Claim.find(params[:id])

    if !@claim.pending? || @claim.requestee != current_account
      render_error("You can't accept this claim.") and return
    end

    @claim.deny!

    if params[:is_last_claim] == 'true'
      flash.now[:notice] = "You've reviewed all the requests!"
    else
      flash.now[:notice] = "You denied #{@claim.requester.first_name}'s request."
    end

    respond_to do |format|
      format.js { render 'accept', locals: { flash: flash, last: params[:is_last_claim] == 'true' } } 
    end
  end
end
