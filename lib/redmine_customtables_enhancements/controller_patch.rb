module RedmineCustomtablesEnhancements
  module ControllerPatch
    def self.included(base)
      base.class_eval do
        before_action :check_custom_table_permissions, only: [:create, :update, :destroy]
      end
    end

    private

    def check_custom_table_permissions
      # try to determine project from params or loaded resources
      project = nil
      project ||= @project if defined?(@project) && @project
      project ||= (@issue.project if defined?(@issue) && @issue)

      # fallback: try params
      if project.nil? && params[:issue_id]
        issue = Issue.find_by_id(params[:issue_id])
        project = issue.project if issue
      end

      return unless project

      case params[:action].to_s
      when 'create'
        deny_access unless User.current.allowed_to?(:add_custom_table_entries, project)
      when 'update'
        deny_access unless User.current.allowed_to?(:edit_custom_table_entries, project)
      when 'destroy'
        deny_access unless User.current.allowed_to?(:delete_custom_table_entries, project)
      end
    end
  end
end

# Patch the controller used by redmine_custom_tables plugin
begin
  if defined?(CustomTables::CustomEntitiesController) && !CustomTables::CustomEntitiesController.included_modules.include?(RedmineCustomtablesEnhancements::ControllerPatch)
    CustomTables::CustomEntitiesController.include RedmineCustomtablesEnhancements::ControllerPatch
  end
rescue NameError
  # if class not defined yet, this will be loaded after plugin initialization by Rails autoload
end