Turbo.StreamActions.update_item_quantity = function () {
    const itemId = parseInt(this.getAttribute("data-item-id"));
    const quantity = parseInt(this.getAttribute("data-quantity"));
    const outOfStock = this.getAttribute("data-out-of-stock") === "true";
    const lowStock = this.getAttribute("data-low-stock") === "true";

    const allItems = document.querySelectorAll('[data-item-filter-target="item"]');

    allItems.forEach(item => {
        const quantityControl = item.querySelector(`#item_${itemId}_quantity`);
        if (quantityControl) {
            item.dataset.itemQuantity = quantity;

            item.classList.remove('out-of-stock', 'low-stock');
            if (outOfStock) {
                item.classList.add('out-of-stock');
            } else if (lowStock) {
                item.classList.add('low-stock');
            }

            if (item.tagName === 'TR') {
                item.querySelectorAll('td').forEach(td => {
                    td.classList.remove('out-of-stock', 'low-stock');
                    if (outOfStock) {
                        td.classList.add('out-of-stock');
                    } else if (lowStock) {
                        td.classList.add('low-stock');
                    }
                });
            }

            const mobileSpan = quantityControl.querySelector('.fw-bold');
            if (mobileSpan) {
                mobileSpan.textContent = quantity;
            }
        }
    });

    const filterElement = document.querySelector('[data-controller="item-filter"]');
    if (filterElement && window.Stimulus) {
        filterElement.dispatchEvent(new CustomEvent('item-quantity-updated', {
            detail: { itemId, quantity, outOfStock, lowStock },
            bubbles: true
        }));
    }
}
