class List < ApplicationRecord
  belongs_to :account
  has_many :list_items, dependent: :destroy
end
