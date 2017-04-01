class CreateProjectPrototypes < ActiveRecord::Migration[5.0]
  def change
    create_table :project_prototypes do |t|
      t.string :prototypable_type
      t.integer :prototypable_id
      t.string :name, limit: 100
      t.jsonb :structure

      t.timestamps
    end
  end
end
