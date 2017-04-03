class CreateDailyCurrencies < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_currencies do |t|
      t.decimal :usd
      t.decimal :eur
      t.date :valid_on

      t.timestamps
    end
  end
end
