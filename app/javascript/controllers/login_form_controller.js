import { Controller } from "@hotwired/stimulus"

// Handles login form submission with enhanced CSRF token support
export default class extends Controller {
    connect() {
        // Ensure CSRF token is fresh when form loads
        this.refreshCSRFToken()

        // Also refresh on page visibility change (e.g., switching tabs back)
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.refreshCSRFToken()
            }
        })
    }

    refreshCSRFToken() {
        const token = document.querySelector('meta[name="csrf-token"]')?.content
        if (token) {
            // Update all CSRF token inputs in the form
            const csrfInputs = this.element.querySelectorAll('input[name="authenticity_token"]')
            csrfInputs.forEach(input => {
                input.value = token
            })

            // Also ensure any Rails UJS tokens are updated
            if (typeof Rails !== 'undefined' && Rails.csrfToken) {
                Rails.csrfToken = () => token
            }
        }
    }

    // Called before form submission
    submit(event) {
        // Refresh CSRF token one more time before submission
        this.refreshCSRFToken()
    }

    disconnect() {
        // Clean up event listener
        document.removeEventListener('visibilitychange', this.refreshCSRFToken)
    }
}
