import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { delay: { type: Number, default: 250 } }

    disconnect() {
        clearTimeout(this.timeout)
    }

    submit() {
        clearTimeout(this.timeout)
        this.element.requestSubmit()
    }

    debouncedSubmit() {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => this.element.requestSubmit(), this.delayValue)
    }

    revert(event) {
        if (event.key !== "Escape") return

        event.preventDefault()
        event.target.value = event.target.defaultValue
        event.target.blur()
    }
}
