# Redmine CustomTables Enhancements

This plugin extends the `redmine_custom_tables` plugin with:
- Auto-capture of user and date for entries
- Auto-fill of fields from previous records
- Popup display of forms in issue view
- Journal updates when forms are modified

### Installation

```bash
cd /data/redmine/plugins
git clone https://github.com/Arean82/redmine_customtables_enhancements.git
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
systemctl restart redmine
````

### Configuration

* Ensure `redmine_custom_tables` plugin is installed and active.
* Add your custom table(s) to projects.
* Edit `customtables_auto_fill.js` to list fields you want auto-populated.

### Compatibility

* Redmine 5.x+
* Works with PostgreSQL and MySQL


## After Installing

1. Go to your issue view → “Open Form” button appears.  
2. Popup shows your project’s custom tables (like your renewal form).  
3. Each record automatically captures:
   - `author` = logged-in user  
   - `created_on` = timestamp  
4. When adding new record:
   - Certain fields (defined in JS) auto-fill from last row  
   - Those fields become read-only  
5. Journal entry is created in the issue history.
