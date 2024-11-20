class AddTagForBrand < ActiveRecord::Migration[8.0]
  def up
    Tag.create([
      { name: 'Exact Brand not Needed' }
    ])
  end

  def down
    raise ActiveRecord::IrreversibleMigration 
  end
end
