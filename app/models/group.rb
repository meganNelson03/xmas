class Group < ApplicationRecord
  has_many :accounts_groups, dependent: :destroy
  has_many :accounts, through: :accounts_groups
  has_many :membership_requests, dependent: :destroy

  has_many :lists, dependent: :nullify

  def total_wishes
    lists.joins(:list_items).pluck('list_items.id').count
  end
end
