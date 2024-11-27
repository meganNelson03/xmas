class MembershipRequest < ApplicationRecord
  include AASM 

  belongs_to :group
  belongs_to :account

  aasm column: :status do
    state :pending, initial: true 
    state :denied 
    state :accepted 
    
    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :deny do
      transitions from: :pending, to: :denied 
    end
  end
end
