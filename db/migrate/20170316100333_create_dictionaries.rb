class CreateDictionaries < ActiveRecord::Migration[5.0]
  def change
    create_table :dictionaries do |t|
      t.string :type, limit: 20
      t.string :title, limit: 100
      t.integer :words_count

      t.timestamps
    end
  end
end
