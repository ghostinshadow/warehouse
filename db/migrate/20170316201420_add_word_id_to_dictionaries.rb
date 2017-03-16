class AddWordIdToDictionaries < ActiveRecord::Migration[5.0]
  def change
    add_column :dictionaries, :word_id, :integer
  end
end
