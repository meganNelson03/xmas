class CreateClaims < ActiveRecord::Migration[8.0]
  def change
    create_table :claims do |t|
      t.references :requester, index: true, foreign_key: { to_table: :accounts }
      t.references :requestee, index: true, foreign_key: { to_table: :accounts }
      t.references :list_item, index: true, foreign_key: true
      t.string :status
      t.timestamps
    end
  end
end
