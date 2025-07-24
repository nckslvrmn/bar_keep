import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["item", "searchInput", "categoryCheckbox", "categoryMatchRadio", "itemTypeSelect", "stockStatusSelect", "resultsCount", "noResults", "needsRestockingBtn"]

    connect() {
        this.filterItems()
        this.updateRestockingButtonState()

        this.boundHandleQuantityUpdate = this.handleQuantityUpdate.bind(this)
        this.element.addEventListener('item-quantity-updated', this.boundHandleQuantityUpdate)
    }

    disconnect() {
        if (this.boundHandleQuantityUpdate) {
            this.element.removeEventListener('item-quantity-updated', this.boundHandleQuantityUpdate)
        }
    }

    handleQuantityUpdate(event) {
        this.filterItems()
    }

    filterItems() {
        const searchTerm = this.searchInputTarget.value.toLowerCase()
        const selectedCategories = this.getSelectedCategories()
        const categoryMatch = this.getCategoryMatch()
        const itemType = this.itemTypeSelectTarget.value
        const stockStatus = this.stockStatusSelectTarget.value

        let matchingItems = 0
        const visibleCategories = new Set()
        const categoryCounts = new Map()
        const processedItems = new Set()

        const allItems = document.querySelectorAll('[data-item-filter-target="item"]')

        allItems.forEach(item => {
            const shouldShow = this.itemMatchesFilters(item, {
                searchTerm,
                selectedCategories,
                categoryMatch,
                itemType,
                stockStatus
            })

            if (shouldShow) {
                item.classList.remove("d-none")

                const itemKey = `${item.dataset.itemName}-${item.dataset.itemType}`

                if (!processedItems.has(itemKey)) {
                    processedItems.add(itemKey)
                    matchingItems++

                    const itemCategories = JSON.parse(item.dataset.itemCategories || "[]")
                    itemCategories.forEach(catId => {
                        const catIdStr = catId.toString()
                        visibleCategories.add(catIdStr)
                        categoryCounts.set(catIdStr, (categoryCounts.get(catIdStr) || 0) + 1)
                    })
                }
            } else {
                item.classList.add("d-none")
            }
        })

        this.updateCategoryVisibility(visibleCategories, categoryCounts)

        if (this.hasResultsCountTarget) {
            this.resultsCountTarget.textContent = `${matchingItems} item${matchingItems !== 1 ? 's' : ''} found`
        }

        if (this.hasNoResultsTarget) {
            if (matchingItems === 0) {
                this.noResultsTarget.classList.remove("d-none")
            } else {
                this.noResultsTarget.classList.add("d-none")
            }
        }
    }

    updateCategoryVisibility(visibleCategories, categoryCounts) {
        this.categoryCheckboxTargets.forEach(checkbox => {
            const categoryId = checkbox.value
            const categoryDiv = checkbox.closest('.form-check')
            const label = categoryDiv.querySelector('.form-check-label')

            const originalText = label.textContent.replace(/ \(\d+\)$/, '')

            if (visibleCategories.has(categoryId)) {
                categoryDiv.classList.remove("d-none")

                const count = categoryCounts.get(categoryId) || 0
                label.textContent = `${originalText} (${count})`
            } else {
                categoryDiv.classList.add("d-none")
            }
        })
    }

    itemMatchesFilters(item, filters) {
        if (filters.searchTerm) {
            const itemName = item.dataset.itemName.toLowerCase()
            if (!itemName.includes(filters.searchTerm)) {
                return false
            }
        }

        if (filters.selectedCategories.length > 0) {
            const itemCategories = JSON.parse(item.dataset.itemCategories || "[]")

            if (filters.categoryMatch === "all") {
                const hasAllCategories = filters.selectedCategories.every(catId =>
                    itemCategories.includes(parseInt(catId))
                )
                if (!hasAllCategories) return false
            } else {
                const hasAnyCategory = filters.selectedCategories.some(catId =>
                    itemCategories.includes(parseInt(catId))
                )
                if (!hasAnyCategory) return false
            }
        }

        if (filters.itemType && item.dataset.itemType !== filters.itemType) {
            return false
        }

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
        this.updateRestockingButtonState()
    }

    clearFilters() {
        this.searchInputTarget.value = ""
        this.categoryCheckboxTargets.forEach(checkbox => checkbox.checked = false)
        this.categoryMatchRadioTargets.find(radio => radio.value === "any").checked = true
        this.itemTypeSelectTarget.value = ""
        this.stockStatusSelectTarget.value = ""
        this.filterItems()
        this.updateRestockingButtonState()
    }

    showOutOfStock() {
        const isCurrentlyFiltered = this.stockStatusSelectTarget.value === "out_of_stock"

        if (isCurrentlyFiltered) {
            this.stockStatusSelectTarget.value = ""
        } else {
            this.stockStatusSelectTarget.value = "out_of_stock"
        }

        this.filterItems()
        this.updateRestockingButtonState()
    }

    updateRestockingButtonState() {
        if (this.hasNeedsRestockingBtnTarget) {
            const isFiltered = this.stockStatusSelectTarget.value === "out_of_stock"
            if (isFiltered) {
                this.needsRestockingBtnTarget.classList.remove("btn-outline-danger")
                this.needsRestockingBtnTarget.classList.add("btn-danger")
            } else {
                this.needsRestockingBtnTarget.classList.remove("btn-danger")
                this.needsRestockingBtnTarget.classList.add("btn-outline-danger")
            }
        }
    }
}
