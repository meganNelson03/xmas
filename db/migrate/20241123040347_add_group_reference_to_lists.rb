class AddGroupReferenceToLists < ActiveRecord::Migration[8.0]
  def change
    add_reference :lists, :group, foreign_key: true, index: true
  end
end
