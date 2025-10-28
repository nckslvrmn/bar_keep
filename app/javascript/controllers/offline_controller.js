import { Controller } from "@hotwired/stimulus"

// Manages offline state detection and UI updates
export default class extends Controller {
  static targets = ["banner", "editButton", "deleteButton", "quantityButton", "addButton"]

  connect() {
    this.updateOnlineStatus()
    window.addEventListener('online', () => this.updateOnlineStatus())
    window.addEventListener('offline', () => this.updateOnlineStatus())
  }

  disconnect() {
    window.removeEventListener('online', () => this.updateOnlineStatus())
    window.removeEventListener('offline', () => this.updateOnlineStatus())
  }

  updateOnlineStatus() {
    const isOnline = navigator.onLine

    if (!isOnline) {
      // Show offline banner
      if (this.hasBannerTarget) {
        this.bannerTarget.classList.remove('d-none')
      }

      // Disable all mutation buttons
      this.editButtonTargets.forEach(btn => {
        btn.disabled = true
        btn.classList.add('opacity-50')
        btn.title = 'Unavailable offline'
      })

      this.deleteButtonTargets.forEach(btn => {
        btn.disabled = true
        btn.classList.add('opacity-50')
        btn.title = 'Unavailable offline'
      })

      this.quantityButtonTargets.forEach(btn => {
        btn.disabled = true
        btn.classList.add('opacity-50')
        btn.title = 'Unavailable offline'
      })

      this.addButtonTargets.forEach(btn => {
        btn.disabled = true
        btn.classList.add('opacity-50')
        btn.title = 'Unavailable offline'
      })
    } else {
      // Hide offline banner
      if (this.hasBannerTarget) {
        this.bannerTarget.classList.add('d-none')
      }

      // Re-enable all mutation buttons
      this.editButtonTargets.forEach(btn => {
        btn.disabled = false
        btn.classList.remove('opacity-50')
        btn.title = ''
      })

      this.deleteButtonTargets.forEach(btn => {
        btn.disabled = false
        btn.classList.remove('opacity-50')
        btn.title = ''
      })

      this.quantityButtonTargets.forEach(btn => {
        btn.disabled = false
        btn.classList.remove('opacity-50')
        btn.title = ''
      })

      this.addButtonTargets.forEach(btn => {
        btn.disabled = false
        btn.classList.remove('opacity-50')
        btn.title = ''
      })
    }
  }
}
