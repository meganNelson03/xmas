class MigrateListItemsCreatedBy < ActiveRecord::Migration[8.0]
  def change
    ListItem.all.each do |list_item|
      list_item.update(created_by_id: list_item.list.account_id)
    end
  end
end
