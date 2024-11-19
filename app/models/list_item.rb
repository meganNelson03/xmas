class ListItem < ApplicationRecord
  belongs_to :list

  enum :priority, [:meh, :wanted, :loved, :adored, :needed]

  validates :description, presence: true
  validate :valid_url
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

  def formatted_priority
    hash = {
      meh: 'Could live without',
      wanted: 'Wanted',
      loved: 'Really Wanted',
      adored: 'Really Really Wanted',
      needed: 'Could not live without'
    }

    hash[priority.to_sym]
  end

  private

  def valid_url 
    return if url.blank?

    regex = /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?\Z/i

    if url.match?(regex)
      if !(url.starts_with?('http://') || url.starts_with?('https://'))
        errors.add(:url, " must include http:// or https://")
        return
      end 
    else
      errors.add(:url, ' is not valid')
    end
  end
end
