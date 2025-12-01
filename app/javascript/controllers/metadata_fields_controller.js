import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    add() {
        this.showModal()
    }

    showModal() {
        const modalHtml = `
            <div class="modal fade" id="addFieldModal" tabindex="-1" aria-labelledby="addFieldModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addFieldModalLabel">Add Custom Field</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="fieldNameInput" class="form-label">Field Name</label>
                                <input type="text" class="form-control" id="fieldNameInput" placeholder="e.g., Purchase Date, Brand, etc." autofocus>
                                <div class="form-text">The field name will be used as the label for this custom field.</div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-primary" id="confirmAddField">Add Field</button>
                        </div>
                    </div>
                </div>
            </div>
        `

        const existingModal = document.getElementById('addFieldModal')
        if (existingModal) {
            existingModal.remove()
        }

        document.body.insertAdjacentHTML('beforeend', modalHtml)

        const modalElement = document.getElementById('addFieldModal')
        const modal = new bootstrap.Modal(modalElement)

        const confirmBtn = document.getElementById('confirmAddField')
        const input = document.getElementById('fieldNameInput')

        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault()
                confirmBtn.click()
            }
        })

        confirmBtn.addEventListener('click', () => {
            const key = input.value.trim()
            if (key) {
                this.addField(key)
                modal.hide()
            } else {
                input.classList.add('is-invalid')
                setTimeout(() => input.classList.remove('is-invalid'), 2000)
            }
        })

        modalElement.addEventListener('hidden.bs.modal', () => {
            modalElement.remove()
        })

        modal.show()

        modalElement.addEventListener('shown.bs.modal', () => {
            input.focus()
        })
    }

    addField(key) {
        const container = this.element
        const field = document.createElement('div')
        field.className = 'metadata-field mb-3'

        const sanitizedKey = key.toLowerCase().replace(/\s+/g, '_')
        field.innerHTML = `
            <label class="form-label">${this.escapeHtml(key)}</label>
            <input type="text" name="metadata[${this.escapeHtml(sanitizedKey)}]" class="form-control" placeholder="${this.escapeHtml(key)}">
        `
        container.appendChild(field)

        field.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
    }

    escapeHtml(text) {
        const div = document.createElement('div')
        div.textContent = text
        return div.innerHTML
    }
}
