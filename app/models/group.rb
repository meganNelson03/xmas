class Group < ApplicationRecord
  # has_many :accounts
  has_many :accounts_groups
  has_many :accounts, through: :accounts_groups

  has_many :lists

  def total_wishes
    lists.joins(:list_items).pluck('list_items.id').count
  end
end
