class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :title
      t.text :text
      t.integer :number_id

      t.timestamps
    end
  end
end
