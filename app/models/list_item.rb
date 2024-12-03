class ListItem < ApplicationRecord
  include AASM
  belongs_to :list
  belongs_to :created_by, class_name: 'Account'
  has_and_belongs_to_many :tags
  has_many :links, dependent: :destroy

  has_many :claims, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  after_update :update_primary_claimant
  after_update :update_status

  enum :priority, [:meh, :wanted, :loved, :adored, :needed]

  validates :description, presence: true
  validates :priority, presence: true
  validate :valid_url
  validates :price, numericality: { less_than: 1000000.00, greater_than_or_equal_to: 0.00 }, allow_nil: true
  validate :can_be_secret

  validate :valid_price_range

  scope :unclaimed, -> { where(claimed_by_id: nil) }
  scope :claimed, -> { where.not(claimed_by_id: nil) }
  scope :owned_by, -> (account) { where(account_id: account.id) }
  scope :in_group, -> (group) { joins(list: :group).where(lists: { groups: { id: group.id }}) }

  delegate :account, to: :list

  aasm column: :status do 
    state :open, initial: true 
    state :claimed
    state :bought

    event :claim do 
      transitions from: :open, to: :claimed
      transitions from: :bought, to: :claimed
    end

    event :mark_as_bought do 
      transitions from: :claimed, to: :bought
    end

    event :reopen do 
      transitions from: :claimed, to: :open
      transitions from: :bought, to: :open
    end
  end

  def self.visible_for(account)
    records = self.joins(:list)

    records
      .where(secret: false, lists: { account_id: account.id })
      .or(records.where.not(lists: { account_id: account.id }))
  end

  def self.claimed_by(account)
    records = self.left_joins(:claims)
    
    records
      .where(claimed_by_id: account.id)
      .or(records.where(claims: { requester_id: account.id, status: 'accepted' }))
  end

  def owned_by?(account)
    list.account_id == account.id
  end

  def is_claimed?
    claimed_by_id.present?
  end

  def is_multi_claimed? 
    claims.accepted.present?
  end

  def claimers
    Account.where(id: claims.accepted.pluck(:requester_id)).or(Account.where(id: claimed_by_id))
  end

  def accepted_claimers 
    Account.where(id: claims.accepted.pluck(:requester_id))
  end

  def pending_claimers
    Account.where(id: claims.pending.pluck(:requester_id))
  end

  def denied_claimers 
    Account.where(id: claims.denied.pluck(:requester_id))
  end

  def claim_for(account)
    claims.find_by(requester_id: account.id)
  end

  def claimed_by?(account)
    claimed_by_id.present? && claimed_by_id == account.id
  end

  def has_a_claim?(account)
    claimed_by_id == account.id ||
    claim_for(account)&.accepted?
  end

  def can_request_to_claim?(account)
    claimed_by_id.present? && claimed_by_id != account.id && claim_for(account).blank?
  end

  def bought_by?(account)
    bought? && claimed_by_id == account.id
  end

  def created_by?(account)
    created_by_id == account.id
  end

  def created_by_someone_else? 
    list.account_id != created_by_id
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

  def update_primary_claimant
    return if !saved_change_to_attribute?(:claimed_by_id)
    return if claimed_by_id.present?

    if claims.accepted.present? 
      new_claimed_by_id = claims.accepted.first.requester_id      
    elsif claims.pending.present? 
      new_claimed_by_id = claims.pending.first.requester_id
    end 

    if new_claimed_by_id.present? 
      self.claimed_by_id = new_claimed_by_id
      self.save(validate: false)

      claims.where(requester_id: new_claimed_by_id).destroy_all
    else 
      claims.destroy_all
    end
  end

  def update_status
    return if !saved_change_to_attribute?(:claimed_by_id)

    if self.open? && claimed_by_id.present? 
      self.claim!
    elsif self.claimed? && claimed_by_id.blank?
      self.reopen!
    end
  end

  def can_be_secret 
    return if created_by_id != list.account_id

    if secret
      errors.add(:secret, ": You can't mark your own wish as a secret.")
    end
  end

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
