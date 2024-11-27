class List < ApplicationRecord
  belongs_to :account
  belongs_to :group
  
  has_many :list_items, dependent: :destroy

  def in_group?(params_group)
    params_group.id == group.id
  end
end
