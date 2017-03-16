class AddDictionaryIdToWords < ActiveRecord::Migration[5.0]
  def change
    add_column :words, :dictionary_id, :integer
  end
end
