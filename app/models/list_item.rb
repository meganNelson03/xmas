class ListItem < ApplicationRecord
  belongs_to :list
  has_and_belongs_to_many :tags
  has_many :links 

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  enum :priority, [:meh, :wanted, :loved, :adored, :needed]

  validates :description, presence: true
  validates :priority, presence: true
  validate :valid_url
  validates :price, numericality: { less_than: 1000000.00, greater_than_or_equal_to: 0.00 }, allow_nil: true

  validate :valid_price_range

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

  def valid_price_range
    return if low_price.blank? && high_price.blank?
    valid_range = 0..1000000

    if high_price.present? && low_price.blank?
      errors.add(:cost, ' needs to have a low price point.') 
    end

    [low_price, high_price].compact_blank.each do |p|
      if !valid_range.include?(p)
        errors.add(:cost, ' must be less than a million bucks. Sorry.')
        return
      end
    end

    if low_price.present? && high_price.present?
      if low_price > high_price
        errors.add(:cost, ' must be less than the high price.')
        return 
      end
    end
  end

  def valid_url 
    return if url.blank?
    return if url =~ URI::regexp

    if !(url.starts_with?('http://') || url.starts_with?('https://'))
      errors.add(:url, " must include http:// or https://") 
    else
      errors.add(:url, ' is not valid')
    end
  end
end
