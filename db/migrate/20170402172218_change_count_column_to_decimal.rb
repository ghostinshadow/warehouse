class ChangeCountColumnToDecimal < ActiveRecord::Migration[5.0]
  def up
    change_column :resources, :count, :decimal, :precision => 10, :scale => 2, null: false
  end

  def down
    change_column :resources, :count, :float, :precision => 10, :scale => 2, null: false
  end
end
