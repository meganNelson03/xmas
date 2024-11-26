class Group < ApplicationRecord

  has_many :accounts_groups, dependent: :delete_all
  has_many :accounts, through: :accounts_groups
  has_many :membership_requests, dependent: :delete_all

  has_many :lists, dependent: :nullify

  has_one :account, foreign_key: :current_group_id, dependent: :nullify

  def total_wishes
    lists.joins(:list_items).pluck('list_items.id').count
  end
end
