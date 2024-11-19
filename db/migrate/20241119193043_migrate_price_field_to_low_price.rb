class MigratePriceFieldToLowPrice < ActiveRecord::Migration[8.0]
  def up
    ListItem.where.not(price: nil).each do |list_item|
      list_item.update(low_price: list_item.price)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration 
  end
end
