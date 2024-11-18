class ListItem < ApplicationRecord
  belongs_to :list

  enum :priority, [:wanted, :loved, :needed]

  validates :description, presence: true
  validates :url, format: { with: /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?\Z/i }, allow_blank: true
  validates :price, numericality: { less_than: 1000000.00, greater_than_or_equal_to: 0.00 }, allow_nil: true

  scope :unclaimed, -> { where(claimed_by_id: nil) }
  scope :claimed, -> { where.not(claimed_by_id: nil) }
  scope :owned_by, -> (account) { where(account_id: account.id) }
  scope :in_group, -> (account) { joins(list: :account).where(lists: { accounts: { account_group_id: account.account_group_id }}) }

  delegate :account, to: :list

  def owned_by?(account)
    list.account_id == account.id
  end

  def claimed?
    claimed_by_id.present?
  end

  def claimed_by?(account)
    claimed_by_id.present? && claimed_by_id == account.id
  end

  def claimed_by 
    Account.find_by(id: claimed_by_id)
  end
end
