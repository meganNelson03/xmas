class CreateMembershipRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :membership_requests do |t|
      t.references :account, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true 
      t.string :status
      t.timestamps
    end
  end
end
