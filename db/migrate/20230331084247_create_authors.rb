class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :a_name
      t.timestamps
    end
    add_index :authors, :a_name, unique: true
  end
end
