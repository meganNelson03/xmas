class AddPriceRangeToListItem < ActiveRecord::Migration[8.0]
  def change
    add_column :list_items, :low_price, :float
    add_column :list_items, :high_price, :float
  end
end
