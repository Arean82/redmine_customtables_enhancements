// -----------------------------------------------------------------------------
// Redmine CustomTables Enhancements
// Dynamic Auto-Fill Script
// -----------------------------------------------------------------------------
// This script fetches enhancement settings for each Custom Table
// (auto-populate fields, read-only fields) from the plugin backend,
// and applies those rules when adding new records.
//
// Requires backend route:
//   GET /custom_table_enhancements/:table_id/settings.json
// -----------------------------------------------------------------------------
//
// Author: Arean
// Version: 0.3.x
// -----------------------------------------------------------------------------

(function() {

  // cache table configs to avoid repeated API calls
  const tableConfigs = {};

  /**
   * Fetch per-table enhancement configuration (JSON)
   * @param {string|number} tableId
   * @returns {Promise<Object>}
   */
  async function fetchTableConfig(tableId) {
    if (tableConfigs[tableId]) return tableConfigs[tableId];

    try {
      const response = await fetch(`/custom_table_enhancements/${tableId}/settings.json`, {
        headers: { 'Accept': 'application/json' }
      });

      if (!response.ok) {
        console.warn(`No enhancement config for table ${tableId}`);
        return {};
      }

      const data = await response.json();
      tableConfigs[tableId] = data || {};
      return tableConfigs[tableId];

    } catch (error) {
      console.error('Error fetching table config:', error);
      return {};
    }
  }

  /**
   * Copies fields from previous record into new one, applies read-only flags
   * @param {Document} doc  - iframe document (Custom Table form)
   * @param {Object} config - table configuration from backend
   */
  function onAddButtonClicked(doc, config) {
    setTimeout(() => {
      const rows = doc.querySelectorAll('form.custom_table_entity, form.custom-table-entity, .custom_entity_form');
      if (rows.length < 2) return; // nothing to copy from

      const lastRow = rows[rows.length - 2];
      const newRow  = rows[rows.length - 1];

      const autoFields = config.auto_populate_fields || [];
      const readOnlyFields = config.read_only_fields || [];

      autoFields.forEach(field => {
        const oldInput = lastRow.querySelector(`[name*='${field}']`);
        const newInput = newRow.querySelector(`[name*='${field}']`);

        if (oldInput && newInput) {
          newInput.value = oldInput.value;

          if (readOnlyFields.includes(field)) {
            newInput.readOnly = true;
            newInput.classList.add('cte-readonly');
            newInput.style.backgroundColor = '#f7f7f7';
            newInput.style.color = '#888';
          }
        }
      });
    }, 400);
  }

  /**
   * Attaches listeners inside each iframe (for each Custom Table form)
   * @param {HTMLIFrameElement} iframe
   */
  async function bindIframe(iframe) {
    try {
      const srcUrl = new URL(iframe.src, window.location.origin);
      const tableId = srcUrl.searchParams.get('table_id');
      if (!tableId) return;

      const config = await fetchTableConfig(tableId);
      const doc = iframe.contentDocument || iframe.contentWindow.document;
      if (!doc) return;

      const addBtn = doc.querySelector('a.icon.icon-add, button.icon.icon-add');
      if (addBtn) {
        addBtn.addEventListener('click', () => onAddButtonClicked(doc, config));
      } else {
        // try to catch dynamically added buttons
        const observer = new MutationObserver(() => {
          const newBtn = doc.querySelector('a.icon.icon-add, button.icon.icon-add');
          if (newBtn) {
            newBtn.addEventListener('click', () => onAddButtonClicked(doc, config));
            observer.disconnect();
          }
        });
        observer.observe(doc.body, { childList: true, subtree: true });
      }
    } catch (error) {
      console.warn('Failed to bind iframe for auto-fill:', error);
    }
  }

  /**
   * Finds all iframes (popup forms) and binds enhancement logic
   */
  function bindAllIframes() {
    const iframes = document.querySelectorAll('iframe');
    if (!iframes.length) return;

    iframes.forEach(iframe => {
      iframe.addEventListener('load', () => bindIframe(iframe));

      // if already loaded
      if (iframe.contentDocument && iframe.contentDocument.readyState === 'complete') {
        bindIframe(iframe);
      }
    });
  }

  // Redmine uses Turbolinks; run on both events
  document.addEventListener('turbolinks:load', bindAllIframes);
  document.addEventListener('DOMContentLoaded', bindAllIframes);

})();
