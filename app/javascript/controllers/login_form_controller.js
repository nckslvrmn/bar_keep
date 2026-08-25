import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.abortController = new AbortController()
        this.refreshCSRFToken()

        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.refreshCSRFToken()
            }
        }, { signal: this.abortController.signal })
    }

    disconnect() {
        this.abortController.abort()
    }

    refreshCSRFToken() {
        const token = document.querySelector('meta[name="csrf-token"]')?.content
        if (!token) return

        this.element.querySelectorAll('input[name="authenticity_token"]').forEach(input => {
            input.value = token
        })
    }

    submit() {
        this.refreshCSRFToken()
    }
}
