import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["item", "searchInput", "categoryCheckbox", "categoryMatchRadio", "itemTypeSelect", "stockStatusSelect", "resultsCount", "noResults"]

    connect() {
        // Initialize filtering when the controller connects
        this.filterItems()
    }

    // Called whenever any filter input changes
    filterItems() {
        const searchTerm = this.searchInputTarget.value.toLowerCase()
        const selectedCategories = this.getSelectedCategories()
        const categoryMatch = this.getCategoryMatch()
        const itemType = this.itemTypeSelectTarget.value
        const stockStatus = this.stockStatusSelectTarget.value

        let visibleCount = 0
        let hiddenCount = 0

        this.itemTargets.forEach(item => {
            const shouldShow = this.itemMatchesFilters(item, {
                searchTerm,
                selectedCategories,
                categoryMatch,
                itemType,
                stockStatus
            })

            if (shouldShow) {
                item.classList.remove("d-none")
                // Only count if the parent container is visible
                if (this.isItemVisible(item)) {
                    visibleCount++
                }
            } else {
                item.classList.add("d-none")
                hiddenCount++
            }
        })

        // Update results count if we have that target
        if (this.hasResultsCountTarget) {
            this.resultsCountTarget.textContent = `${visibleCount} item${visibleCount !== 1 ? 's' : ''} found`
        }

        // Show/hide "no results" message based on whether ANY items are visible
        if (this.hasNoResultsTarget) {
            if (visibleCount === 0) {
                this.noResultsTarget.classList.remove("d-none")
            } else {
                this.noResultsTarget.classList.add("d-none")
            }
        }
    }

    itemMatchesFilters(item, filters) {
        // Search filter
        if (filters.searchTerm) {
            const itemName = item.dataset.itemName.toLowerCase()
            if (!itemName.includes(filters.searchTerm)) {
                return false
            }
        }

        // Category filter
        if (filters.selectedCategories.length > 0) {
            const itemCategories = JSON.parse(item.dataset.itemCategories || "[]")

            if (filters.categoryMatch === "all") {
                // Item must have ALL selected categories
                const hasAllCategories = filters.selectedCategories.every(catId =>
                    itemCategories.includes(parseInt(catId))
                )
                if (!hasAllCategories) return false
            } else {
                // Item must have ANY of the selected categories
                const hasAnyCategory = filters.selectedCategories.some(catId =>
                    itemCategories.includes(parseInt(catId))
                )
                if (!hasAnyCategory) return false
            }
        }

        // Item type filter
        if (filters.itemType && item.dataset.itemType !== filters.itemType) {
            return false
        }

        // Stock status filter
        if (filters.stockStatus) {
            const quantity = parseInt(item.dataset.itemQuantity)
            const lowStockThreshold = parseInt(item.dataset.itemLowStockThreshold || "5")

            switch (filters.stockStatus) {
                case "in_stock":
                    if (quantity === 0 || quantity <= lowStockThreshold) return false
                    break
                case "low_stock":
                    if (quantity === 0 || quantity > lowStockThreshold) return false
                    break
                case "out_of_stock":
                    if (quantity !== 0) return false
                    break
            }
        }

        return true
    }

    getSelectedCategories() {
        return this.categoryCheckboxTargets
            .filter(checkbox => checkbox.checked)
            .map(checkbox => checkbox.value)
    }

    getCategoryMatch() {
        const checkedRadio = this.categoryMatchRadioTargets.find(radio => radio.checked)
        return checkedRadio ? checkedRadio.value : "any"
    }

    // Event handlers
    onSearchInput() {
        this.filterItems()
    }

    onCategoryChange() {
        this.filterItems()
    }

    onCategoryMatchChange() {
        this.filterItems()
    }

    onItemTypeChange() {
        this.filterItems()
    }

    onStockStatusChange() {
        this.filterItems()
    }

    clearFilters() {
        this.searchInputTarget.value = ""
        this.categoryCheckboxTargets.forEach(checkbox => checkbox.checked = false)
        this.categoryMatchRadioTargets.find(radio => radio.value === "any").checked = true
        this.itemTypeSelectTarget.value = ""
        this.stockStatusSelectTarget.value = ""
        this.filterItems()
    }

    // Check if the item's parent container is visible
    isItemVisible(item) {
        // Check if this is a table row (desktop view)
        if (item.tagName === 'TR') {
            const table = item.closest('.table-responsive')
            return table && !table.classList.contains('d-none') && window.getComputedStyle(table).display !== 'none'
        }

        // Check if this is a mobile card
        if (item.classList.contains('mobile-item-card')) {
            const mobileContainer = item.closest('.d-md-none')
            return mobileContainer && window.getComputedStyle(mobileContainer).display !== 'none'
        }

        return true
    }
}
