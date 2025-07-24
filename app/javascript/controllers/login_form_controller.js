import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.refreshCSRFToken()

        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.refreshCSRFToken()
            }
        })
    }

    refreshCSRFToken() {
        const token = document.querySelector('meta[name="csrf-token"]')?.content
        if (token) {
            const csrfInputs = this.element.querySelectorAll('input[name="authenticity_token"]')
            csrfInputs.forEach(input => {
                input.value = token
            })

            if (typeof Rails !== 'undefined' && Rails.csrfToken) {
                Rails.csrfToken = () => token
            }
        }
    }

    submit(event) {
        this.refreshCSRFToken()
    }

    disconnect() {
        document.removeEventListener('visibilitychange', this.refreshCSRFToken)
    }
}
