class CreateShippings < ActiveRecord::Migration[5.0]
  def change
    create_table :shippings do |t|
      t.string :package_variant, limit: 20
      t.date :shipping_date

      t.timestamps
    end
  end
end
