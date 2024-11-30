module ApplicationHelper

  def format_price(price, precision = 2)
    return "$0.00" if price.blank?
    "$" + number_with_precision(price, :precision => precision, :delimiter => ',')
  end

  def format_price_range(low_price = nil, high_price = nil)
    if low_price.blank? && high_price.blank?
      return "$0.00"
    end

    if (value = [low_price, high_price].compact_blank.uniq).length == 1 
      return format_price(value.first)
    end

    if low_price.present? && high_price.present?
      return format_price(low_price, 0) + " - " + format_price(high_price, 0) 
    end
  end

  def format_accounts_list(accounts)
    accounts.map do |account| 
      account.first_name
    end.compact_blank.join(', ')
  end

  def recipient_options
    current_account.members_in_selected_group(@selected_group).where.not(id: current_account.id).order(first_name: :asc).map {
      |a| [a.full_name, a.id]
    }
  end

  def account_list_options 
    available_accounts = current_account.members_in_selected_group(@selected_group).where.not(id: current_account.id).order(first_name: :asc)
    lists = List.where(group_id: @selected_group.id, account_id: available_accounts.ids).joins(:account).order('accounts.first_name asc')

    result = lists.map {
      |l| [l.account.full_name, l.id]
    }

    result.unshift(['Myself', current_account.current_list.id])
  end

  def account_options
    current_account.members_in_selected_group(@selected_group).order(first_name: :asc).map {
      |a| [a.full_name, a.id]
    }
  end

  def is_valid_email?(email)
    regex = /^[\w.+\-]+@gmail\.com$/

    email.match?(regex)
  end

  def sort_options
    [
      ['Price (Low to High)', 'price_asc'],
      ['Price (High to Low)', 'price_desc'],
      ['Priority (High to Low)', 'priority_desc'],
      ['Priority (Low to High)', 'priority_asc']
    ]
  end

  def claim_options
    [
      ['All', 'all'],
      ['Unclaimed', 'open'],
      ['Claimed', 'claimed'],
      ['Bought', 'bought']
    ]
  end

  def priority_options
    [
      ['I can live without it', :meh],
      ['I want it', :wanted],
      ['I really want it', :loved],
      ['I really really want it', :adored],
      ["I can't live without it", :needed]
    ]
  end

  def render_errors(object, field)
    return if object.errors.blank? 
    return if object.errors&.messages[field]&.blank?

    render partial: "layouts/error", locals: { field: field, error: object.errors.messages[field] } 
  end
end
