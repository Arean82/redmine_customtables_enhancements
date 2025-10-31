
document.addEventListener('turbolinks:load', function() {
  const addBtn = document.querySelector('a.icon.icon-add, button.icon.icon-add');
  if (!addBtn) return;

  addBtn.addEventListener('click', function() {
    setTimeout(() => {
      const rows = document.querySelectorAll('form.custom-table-entity');
      if (rows.length < 2) return;

      const lastRow = rows[rows.length - 2];
      const newRow = rows[rows.length - 1];

      // Define which fields to auto-fill
      const fieldsToCopy = ['vehicle_id', 'customer_name', 'location'];

      fieldsToCopy.forEach(field => {
        const oldInput = lastRow.querySelector(`[name*='${field}']`);
        const newInput = newRow.querySelector(`[name*='${field}']`);
        if (oldInput && newInput) {
          newInput.value = oldInput.value;
          newInput.readOnly = true;
          newInput.style.backgroundColor = '#f9f9f9';
        }
      });
    }, 500);
  });
});
