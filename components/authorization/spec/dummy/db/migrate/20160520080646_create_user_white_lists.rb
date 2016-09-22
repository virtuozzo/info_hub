class CreateUserWhiteLists < ActiveRecord::Migration
  def change
    create_table :user_white_lists do |t|
      t.integer :user_id, null: false
      t.string :ip
      t.string :description
      t.timestamps
    end
  end
end
