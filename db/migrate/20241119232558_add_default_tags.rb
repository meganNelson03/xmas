class AddDefaultTags < ActiveRecord::Migration[8.0]
  def up
    Tag.create([
      { name: 'Ask me for Details' },
      { name: 'This is a Reach' },
      { name: 'Prefer Exact Brand' },
      { name: 'Okay with Cheap' },
      { name: 'Want High Quality' },
      { name: "Don't go Overboard" },
      { name: 'Please Source Ethically' }
    ])
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end