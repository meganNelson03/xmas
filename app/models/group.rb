class Group < ApplicationRecord

  has_many :accounts_groups, dependent: :delete_all
  has_many :accounts, through: :accounts_groups
  has_many :membership_requests, dependent: :delete_all

  has_many :lists, dependent: :nullify

  has_one :account, foreign_key: :current_group_id, dependent: :nullify

  belongs_to :administrator, class_name: 'Account'

  validates_length_of :name, minimum: 5, maximum: 30, allow_blank: false 
  validates_associated :lists
  validate :unique_name

  def total_wishes
    lists.joins(:list_items).pluck('list_items.id').count
  end

  private 

  def unique_name 
    return if administrator.blank? 

    if administrator.groups.pluck(:name).include?(name)
      errors.add(:name, ' must be unique among your groups.')
    end
  end
end
