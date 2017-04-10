class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :aasm_state, limit: 50
      t.integer :shipping_id

      t.timestamps
    end
  end
end
