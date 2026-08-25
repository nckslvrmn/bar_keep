import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "itemsView"
const DEFAULT_VIEW = "rows"

export default class extends Controller {
    static targets = ["button"]

    connect() {
        this.render()
    }

    select({ params: { view } }) {
        document.documentElement.setAttribute("data-items-view", view)

        try {
            localStorage.setItem(STORAGE_KEY, view)
        } catch {}

        this.render()
    }

    render() {
        const current = document.documentElement.getAttribute("data-items-view") || DEFAULT_VIEW

        this.buttonTargets.forEach(button => {
            const active = button.dataset.viewToggleViewParam === current
            button.classList.toggle("active", active)
            button.setAttribute("aria-pressed", active)
        })
    }
}
