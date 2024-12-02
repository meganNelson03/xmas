class Claim < ApplicationRecord
  include AASM

  belongs_to :requester, class_name: 'Account'
  belongs_to :requestee, class_name: 'Account' 
  belongs_to :list_item

  aasm column: :status do 
    state :pending, initial: true 
    state :accepted
    state :denied

    event :accept do 
      transitions from: :pending, to: :accepted
    end

    event :deny do 
      transitions from: :pending, to: :denied
    end
  end
end
