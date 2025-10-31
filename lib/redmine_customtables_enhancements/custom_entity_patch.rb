module RedmineCustomtablesEnhancements
  module CustomEntityPatch
    def self.included(base)
      base.class_eval do
        before_create :set_author_and_date
        after_create  :log_creation_to_issue
        after_update  :log_update_to_issue
        after_destroy :log_deletion_to_issue
      end
    end

    def set_author_and_date
      self.author_id ||= User.current.id if User.current && User.current.logged?
      self.created_on ||= Time.now if respond_to?(:created_on)
    end

    def log_creation_to_issue
      mirror_change_to_issue(:create, attributes)
    end

    def log_update_to_issue
      changed = previous_changes.dup
      # remove noisy columns
      changed.delete('updated_on')
      changed.delete('updated_at')
      mirror_change_to_issue(:update, changed)
    end

    def log_deletion_to_issue
      mirror_change_to_issue(:destroy, attributes)
    end

    private

    def mirror_change_to_issue(action, details)
      return unless issue && User.current && User.current.logged?

      table_name = (respond_to?(:custom_table) && custom_table && custom_table.name) ? custom_table.name : 'Custom Table'
      case action
      when :create
        message = "Added new #{table_name} entry (ID: #{id})"
      when :update
        message = "Updated #{table_name} entry (ID: #{id})"
      when :destroy
        message = "Deleted #{table_name} entry (ID: #{id})"
      end

      journal = issue.init_journal(User.current, message)

      # Build JournalDetail-like details
      details.each do |k, v|
        next if k.to_s == 'id'

        old_value = nil
        new_value = nil

        if v.is_a?(Array)
          old_value = v[0]
          new_value = v[1]
        else
          # for create/destroy we store current value in :value
          new_value = v unless action == :destroy
          old_value = v if action == :destroy
        end

        # prop_key: we use custom table name + field for clarity
        prop_key = "#{table_name}_#{k}"

        journal.details.build(property: 'cf', prop_key: prop_key, old_value: old_value.to_s, value: new_value.to_s)
      end

      issue.save
    end
  end
end

# include the patch into CustomEntity (if class name differs, adjust accordingly)
begin
  require_dependency 'custom_tables/custom_entity' if defined?(CustomTables)
rescue LoadError
  # ignore
end

if defined?(CustomEntity) && !CustomEntity.included_modules.include?(RedmineCustomtablesEnhancements::CustomEntityPatch)
  CustomEntity.include RedmineCustomtablesEnhancements::CustomEntityPatch
end