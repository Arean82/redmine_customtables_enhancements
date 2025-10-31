class CreateCustomTableEnhancements < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_table_enhancements do |t|
      t.integer :custom_table_id, null: false
      t.text :auto_populate_fields
      t.text :read_only_fields
      t.boolean :enable_journaling, default: true
      t.boolean :capture_author_date, default: true
      t.timestamps
    end

    add_index :custom_table_enhancements, :custom_table_id, unique: true
  end
end
