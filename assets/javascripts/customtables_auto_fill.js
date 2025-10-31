// This file auto-copies values from the last row to the new row and locks the copied inputs.
// Edit `fieldsToCopy` to contain the field 'name' substrings used by your custom table inputs.

(function() {
  function onFrameLoaded(iframe) {
    try {
      var doc = iframe.contentDocument || iframe.contentWindow.document;
      bindAddButtonInDoc(doc);
    } catch(e) {
      // cross-origin or not ready
    }
  }

  function bindAddButtonInDoc(doc) {
    var addBtn = doc.querySelector('a.icon.icon-add, button.icon.icon-add');
    if(!addBtn) return;

    addBtn.addEventListener('click', function() {
      setTimeout(function() {
        var rows = doc.querySelectorAll('form.custom_table_entity, form.custom-table-entity, .custom_entity_form');
        if(rows.length < 2) return;

        var lastRow = rows[rows.length - 2];
        var newRow = rows[rows.length - 1];

        var fieldsToCopy = ['vehicle_id', 'customer_name', 'location']; // <-- customize these

        fieldsToCopy.forEach(function(field) {
          var oldInput = lastRow.querySelector("[name*='" + field + "']");
          var newInput = newRow.querySelector("[name*='" + field + "']");
          if(oldInput && newInput) {
            newInput.value = oldInput.value;
            newInput.readOnly = true;
            newInput.classList.add('cte-readonly');
          }
        });
      }, 300);
    });
  }

  function bindAllIframes() {
    document.querySelectorAll('iframe').forEach(function(iframe) {
      iframe.addEventListener('load', function() { onFrameLoaded(iframe); });
      // if already loaded
      if(iframe.contentDocument && iframe.contentDocument.readyState === 'complete') onFrameLoaded(iframe);
    });
  }

  document.addEventListener('turbolinks:load', bindAllIframes);
  document.addEventListener('DOMContentLoaded', bindAllIframes);
})();