
class CustomTableEnhancement < ActiveRecord::Base
  unloadable
  belongs_to :custom_table, class_name: 'CustomTables::CustomTable'

  serialize :auto_populate_fields, Array
  serialize :read_only_fields, Array

  validates :custom_table_id, presence: true, uniqueness: true
end