import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    // Page refreshes morph in the server's open state, which would collapse a section the user expanded.
    keepOpenState(event) {
        if (event.target === this.element && event.detail.attributeName === "open") {
            event.preventDefault()
        }
    }
}
