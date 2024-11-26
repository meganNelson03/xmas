class AccountsGroup < ApplicationRecord
  belongs_to :account 
  belongs_to :group

  after_create :create_list 

  private 

  def create_list
    account.lists.create(group_id: group_id)
  end
end