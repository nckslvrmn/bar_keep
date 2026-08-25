import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner", "editButton", "deleteButton", "quantityButton", "addButton"]

  connect() {
    this.abortController = new AbortController()
    this.updateOnlineStatus()

    window.addEventListener('online', () => this.updateOnlineStatus(), { signal: this.abortController.signal })
    window.addEventListener('offline', () => this.updateOnlineStatus(), { signal: this.abortController.signal })
  }

  disconnect() {
    this.abortController.abort()
  }

  editButtonTargetConnected(button) { this.updateButtonState(button, navigator.onLine) }
  deleteButtonTargetConnected(button) { this.updateButtonState(button, navigator.onLine) }
  quantityButtonTargetConnected(button) { this.updateButtonState(button, navigator.onLine) }
  addButtonTargetConnected(button) { this.updateButtonState(button, navigator.onLine) }

  updateOnlineStatus() {
    const isOnline = navigator.onLine

    if (this.hasBannerTarget) {
      this.bannerTarget.classList.toggle('d-none', isOnline)
    }

    const buttons = [
      ...this.editButtonTargets,
      ...this.deleteButtonTargets,
      ...this.quantityButtonTargets,
      ...this.addButtonTargets
    ]

    buttons.forEach(button => this.updateButtonState(button, isOnline))
  }

  updateButtonState(button, isOnline) {
    button.disabled = !isOnline
    button.classList.toggle('opacity-50', !isOnline)
    button.title = isOnline ? '' : 'Unavailable offline'
  }
}
