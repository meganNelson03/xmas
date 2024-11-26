class MigrateAccountStatus < ActiveRecord::Migration[8.0]
  def change
    Account.where(status: nil).each do |account|
      account.active!
    end
  end
end
