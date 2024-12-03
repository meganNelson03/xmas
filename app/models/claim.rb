class Claim < ApplicationRecord
  include AASM

  belongs_to :requester, class_name: 'Account'
  belongs_to :requestee, class_name: 'Account' 
  belongs_to :list_item

  validates :requester_id, uniqueness: { scope: :list_item_id }

  aasm column: :status do 
    state :pending, initial: true 
    state :accepted
    state :denied
    state :revoked

    event :accept do 
      transitions from: :pending, to: :accepted
    end

    event :deny do 
      transitions from: :pending, to: :denied
    end

    event :revoke do
      transitions from: :accepted, to: :revoked 
    end

    event :reinstate do 
      transitions from: :revoked, to: :accepted
    end
  end
end
