require 'redmine'
require_dependency 'redmine_customtables_enhancements'

Redmine::Plugin.register :redmine_customtables_enhancements do
  name 'Redmine CustomTables Enhancements'
  author 'Arean'
  description 'Enhancements for Redmine Custom Tables - popup forms, auto-fill fields, and journal tracking'
  version '0.1.0'
  url 'https://github.com/Arean82/redmine_customtables_enhancements'
  #author_url 'https://yourcompany.example.com'

  Rails.application.config.after_initialize do
    Redmine::Hook::ViewListener.class_eval do
      def view_layouts_base_html_head(_context = {})
        javascript_include_tag('customtables_auto_fill', plugin: 'redmine_customtables_enhancements')
      end
    end
  end
end
