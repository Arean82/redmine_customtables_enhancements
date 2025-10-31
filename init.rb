
require 'redmine'
require_dependency 'redmine_customtables_enhancements'

Redmine::Plugin.register :redmine_customtables_enhancements do
  name 'Redmine CustomTables Enhancements'
  author 'Arean'
  description 'Enhancements for redmine_custom_tables: popup forms, auto-fill fields, journal mirroring, fine-grained permissions.'
  version '0.3.0'
  url 'https://github.com/Arean82/redmine_customtables_enhancements'
  requires_redmine version_or_higher: '5.0.0'

  project_module :custom_tables do
    permission :view_custom_tables, {}
    permission :add_custom_table_entries, {}
    permission :edit_custom_table_entries, {}
    permission :delete_custom_table_entries, {}
  end

  # Make sure our assets are available in layouts
  Rails.application.config.to_prepare do
    require_dependency 'redmine_customtables_enhancements'
  end
end