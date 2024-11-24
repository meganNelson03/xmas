class List < ApplicationRecord
  belongs_to :account
  belongs_to :group
  
  has_many :list_items, dependent: :destroy
end
