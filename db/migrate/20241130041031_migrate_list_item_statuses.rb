class MigrateListItemStatuses < ActiveRecord::Migration[8.0]
  def change
    ListItem.where(status: 'open').each do |list_item|
      if list_item.claimed_by_id.present? 
        list_item.update(status: 'claimed')
      end
    end
  end
end
