class ListController < ApplicationController
  before_action :set_list_items, only: [:index, :my_claims]

  def index 
    @list_items = filter(@list_items, params[:filters])
    @list_items = sort(@list_items, params[:filters])

    @account = Account.find_by(id: params.dig(:filters, :account))

    @total = @list_items.count
    @totaled_items = @list_items.joins(:list).where.not(lists: { account_id: current_account.id })

    @unclaimed = @totaled_items.where(claimed_by_id: nil).count
    @claimed_by_me = @totaled_items.where(claimed_by_id: current_account.id).count
    @claimed_by_others = @totaled_items.where.not(claimed_by_id: [nil, current_account.id]).count

    @list_items = @list_items.distinct.page(params[:page]).per(10)
  end

  def my_claims
    @list_items = @list_items.claimed.where(claimed_by_id: current_account.id)
    @list_items = filter(@list_items, params[:filters])
    @list_items = sort(@list_items, params[:filters])

    @total = @list_items.count

    @list_items = @list_items.page(params[:page]).per(10)
  end

  def filter(list_items, params)
    return list_items if params.blank? 

    if params[:account].present?
      list_items = list_items.joins(:list).where(lists: { account_id: params[:account] })
    end

    if params[:recipient_id].present? 
      list_items = list_items.joins(:list).where(lists: { account_id: params[:recipient_id] })
    end

    if (statuses = status_query(params[:status])).present? 
      list_items = list_items.joins(:list).where.not(lists: { account_id: current_account.id }).where(status: statuses)
    end

    return list_items
  end

  def sort(list_items, params)
    return list_items if params.blank?
    return list_items if (sort = params.dig(:sort_by)).blank?

    case sort
    when 'first_name_asc'
      list_items = list_items.reorder(first_name: :asc)
    when 'first_name_desc'
      list_items = list_items.reorder(first_name: :desc)
    when 'price_asc'
      list_items = list_items.reorder('low_price asc NULLS first')
    when 'price_desc'
      list_items = list_items.reorder('low_price desc NULLS last')
    when 'priority_desc'
      list_items = list_items.reorder(priority: :desc)
    when 'priority_asc'
      list_items = list_items.reorder(priority: :asc)
    else 
      list_items
    end

    return list_items
  end

  private 

  def set_list_items
    if @selected_group.blank?
      @list_items = ListItem.none
    else 
      @list_items = ListItem.in_group(@selected_group)
    end 
  end

  def status_query(status)
    case status
    when 'all'
      nil
    when 'open'
      'open'
    when 'claimed'
      ['claimed', 'bought']
    when 'bought'
      ['bought']
    end
  end
end