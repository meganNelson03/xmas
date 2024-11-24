class MigrateGroupsToHaveName < ActiveRecord::Migration[8.0]
  def change
    Group.all.update_all(name: 'Primary Group')
  end
end
