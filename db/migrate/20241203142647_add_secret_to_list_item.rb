class AddSecretToListItem < ActiveRecord::Migration[8.0]
  def change
    add_column :list_items, :secret, :boolean, default: false
  end
end
