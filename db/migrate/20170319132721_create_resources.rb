class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.integer :name_id
      t.integer :category_id
      t.string :type
      t.integer :unit_id
      t.decimal :price_uah, default: 0.0,  precision: 5, scale: 2
      t.decimal :price_usd, default: 0.0,  precision: 5, scale: 2
      t.decimal :price_eur, default: 0.0,  precision: 5, scale: 2
      t.float :count, default: 0.0

      t.timestamps
    end
  end
end
