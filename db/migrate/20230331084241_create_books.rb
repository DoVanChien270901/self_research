class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, unique: true
      t.string :publisher
      t.integer :price
      t.timestamps
    end
  end
end
