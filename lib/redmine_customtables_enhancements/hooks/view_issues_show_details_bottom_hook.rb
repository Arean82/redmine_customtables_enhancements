#  view_issues_show_details_bottom_hook.rb

module RedmineCustomtablesEnhancements
  module Hooks
    class ViewIssuesShowDetailsBottomHook < Redmine::Hook::ViewListener
      render_on :view_issues_show_details_bottom, partial: 'popup/form_popup'
    end
  end
end
