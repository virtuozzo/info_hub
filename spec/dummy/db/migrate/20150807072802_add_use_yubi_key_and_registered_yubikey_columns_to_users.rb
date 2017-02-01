class AddUseYubiKeyAndRegisteredYubikeyColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :registered_yubikey, :string, limit: 12
  end
end
