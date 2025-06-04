import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    add() {
        const container = this.element
        const field = document.createElement('div')
        field.className = 'metadata-field mb-3'

        const key = prompt('Field name:')
        if (key) {
            const sanitizedKey = key.toLowerCase().replace(/\s+/g, '_')
            field.innerHTML = `
                <label class="form-label">${key}</label>
                <input type="text" name="metadata[${sanitizedKey}]" class="form-control" placeholder="${key}">
            `
            container.appendChild(field)
        }
    }
}
