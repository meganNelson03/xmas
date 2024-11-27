class MigrateAccountsToGroup < ActiveRecord::Migration[8.0]
  def change
    Account.where.not(group_id: nil).each do |account| 
      group = Group.find_by(id: account.group_id)
      list = account.lists&.first 

      next if group.blank?

      if list.present?
        list.update(group_id: group.id) 
      end

      if account.groups.blank? 
        account.groups << group
        account.save!
      end
    end
  end
end
