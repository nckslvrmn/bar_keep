import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner", "editButton", "deleteButton", "quantityButton", "addButton"]

  connect() {
    this.boundUpdateStatus = this.updateOnlineStatus.bind(this)
    this.updateOnlineStatus()
    window.addEventListener('online', this.boundUpdateStatus)
    window.addEventListener('offline', this.boundUpdateStatus)
  }

  disconnect() {
    window.removeEventListener('online', this.boundUpdateStatus)
    window.removeEventListener('offline', this.boundUpdateStatus)
  }

  updateOnlineStatus() {
    const isOnline = navigator.onLine

    if (this.hasBannerTarget) {
      this.bannerTarget.classList.toggle('d-none', isOnline)
    }

    const targetNames = ['edit', 'delete', 'quantity', 'add']
    targetNames.forEach(targetName => {
      const targets = this[`${targetName}ButtonTargets`]
      if (targets) {
        targets.forEach(btn => this.updateButtonState(btn, isOnline))
      }
    })
  }

  updateButtonState(button, isOnline) {
    button.disabled = !isOnline
    button.classList.toggle('opacity-50', !isOnline)
    button.title = isOnline ? '' : 'Unavailable offline'
  }
}
