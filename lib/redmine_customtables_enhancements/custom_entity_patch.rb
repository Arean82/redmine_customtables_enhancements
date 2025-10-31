module RedmineCustomtablesEnhancements
  module CustomEntityPatch
    def self.included(base)
      base.class_eval do
        before_create :set_author_and_date
        after_save :write_to_issue_history
      end
    end

    def set_author_and_date
      self.author_id ||= User.current.id if User.current.logged?
      self.created_on ||= Time.now
    end

    def write_to_issue_history
      return unless issue && User.current.logged?
      message = "Form '#{custom_table.name}' updated by #{User.current.name}"
      issue.init_journal(User.current, message)
      issue.save
    end
  end
end

CustomEntity.include RedmineCustomtablesEnhancements::CustomEntityPatch unless CustomEntity.included_modules.include?(RedmineCustomtablesEnhancements::CustomEntityPatch)
