#  view_issues_show_details_bottom_hook.rb

module RedmineCustomtablesEnhancements
  module Hooks
    class ViewIssuesShowDetailsBottomHook < Redmine::Hook::ViewListener
      # include our javascript and render popup partial
      def view_layouts_base_html_head(context = {})
        # include plugin assets
        js = javascript_include_tag('customtables_auto_fill', plugin: 'redmine_customtables_enhancements')
        js + javascript_include_tag('customtables_permissions_ui', plugin: 'redmine_customtables_enhancements')
      end

      render_on :view_issues_show_details_bottom, partial: 'popup/form_popup'
    end
  end
end