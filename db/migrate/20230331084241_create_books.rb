class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, unique: true
      t.string :binding
      t.string :publisher
      t.string :language
      t.string :image_src
      t.float :price
      t.date :release_date
      t.timestamps
    end
  end
end
