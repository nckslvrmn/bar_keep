import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["icon"]

    connect() {
        this.abortController = new AbortController()
        this.updateIcon()

        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (event) => {
            if (!localStorage.getItem('theme')) {
                this.apply(event.matches ? 'dark' : 'light')
            }
        }, { signal: this.abortController.signal })
    }

    disconnect() {
        this.abortController.abort()
    }

    toggle() {
        const currentTheme = document.documentElement.getAttribute('data-bs-theme')
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark'

        localStorage.setItem('theme', newTheme)
        this.apply(newTheme)
    }

    apply(theme) {
        document.documentElement.setAttribute('data-bs-theme', theme)
        this.updateThemeColor()
        this.updateIcon()
    }

    updateThemeColor() {
        const meta = document.querySelector('meta[name="theme-color"]')
        const color = getComputedStyle(document.documentElement).getPropertyValue('--navbar-bg').trim()

        if (meta && color) {
            meta.content = color
        }
    }

    updateIcon() {
        const theme = document.documentElement.getAttribute('data-bs-theme')

        if (this.hasIconTarget) {
            this.iconTarget.textContent = theme === 'dark' ? '☀️' : '🌙'
        }
    }
}
