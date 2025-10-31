# redmine_customtables_enhancements


Plugin that extends redmine_custom_tables by:
- popup UI from issue view
- auto-capture author/date
- auto-copy selected fields to new entries and lock them
- mirror create/update/delete to the parent issue's journals
- fine-grained permissions (add/edit/delete)


## Installation


1. Ensure `redmine_custom_tables` plugin is installed and migrated.
2. Copy this plugin into `REDMINE_ROOT/plugins`.
3. Run:
```bash
bundle install --without development test
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
systemctl restart redmine # or restart passenger/unicorn/puma
```
4. Go to **Administration → Roles and permissions** and grant the following permissions (under module 'Custom tables') as needed:
- View custom tables (existing permission)
- Add entries to custom tables
- Edit custom table entries
- Delete custom table entries


## Configuration
- Open `assets/javascripts/customtables_auto_fill.js` and edit `fieldsToCopy` to match the form field names you want to persist from previous row.
- If you want the read-only style changed, add CSS to your Redmine stylesheet or in the plugin views.


## Notes
- UI-level hiding of buttons is best-effort; the controller patch enforces permissions on backend.
- If your redmine_custom_tables plugin uses different controller/class names, adjust the controller patch accordingly.
