#module RedmineCustomtablesEnhancements
#end
#
#require_dependency 'redmine_customtables_enhancements/custom_entity_patch'
#require_dependency 'redmine_customtables_enhancements/controller_patch'
#require_dependency 'redmine_customtables_enhancements/hooks/view_issues_show_details_bottom_hook'

# frozen_string_literal: true

plugin_root = File.expand_path('..', __dir__)

require File.join(plugin_root, 'redmine_customtables_enhancements', 'custom_entity_patch')
require File.join(plugin_root, 'redmine_customtables_enhancements', 'controller_patch')
require File.join(plugin_root, 'redmine_customtables_enhancements', 'hooks', 'view_issues_show_details_bottom_hook')

