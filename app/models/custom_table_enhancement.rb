class CustomTableEnhancement < ActiveRecord::Base
  belongs_to :custom_table, class_name: 'CustomTables::CustomTable'

  serialize :auto_populate_fields, Array
  serialize :read_only_fields, Array

  validates :custom_table_id, presence: true, uniqueness: true

  def fields_for_select
    custom_table.custom_fields.map { |f| [f.name, f.name] }
  end
end
