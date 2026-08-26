import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["field", "option"]

    connect() {
        this.sync()
    }

    toggle({ params: { name } }) {
        const names = this.names
        const index = names.findIndex(existing => existing.toLowerCase() === name.toLowerCase())

        if (index === -1) {
            names.push(name)
        } else {
            names.splice(index, 1)
        }

        this.fieldTarget.value = names.join(", ")
        this.sync()
    }

    sync() {
        const selected = this.names.map(name => name.toLowerCase())

        this.optionTargets.forEach(option => {
            const active = selected.includes(option.dataset.categoryPickerNameParam.toLowerCase())
            option.classList.toggle("active", active)
            option.setAttribute("aria-pressed", active)
        })
    }

    get names() {
        return this.fieldTarget.value.split(",").map(name => name.trim()).filter(Boolean)
    }
}
