import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["icon"]

    connect() {
        this.updateIcon()

        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
            if (!localStorage.getItem('theme')) {
                const theme = e.matches ? 'dark' : 'light'
                document.documentElement.setAttribute('data-bs-theme', theme)
                this.updateIcon()
            }
        })
    }

    toggle() {
        const currentTheme = document.documentElement.getAttribute('data-bs-theme')
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark'

        document.documentElement.setAttribute('data-bs-theme', newTheme)
        localStorage.setItem('theme', newTheme)
        this.updateIcon()

        const metaThemeColor = document.querySelector('meta[name="theme-color"]')
        if (metaThemeColor) {
            metaThemeColor.content = newTheme === 'dark' ? '#2c2c2c' : '#e8e8e8'
        }
    }

    updateIcon() {
        const theme = document.documentElement.getAttribute('data-bs-theme')
        if (this.hasIconTarget) {
            this.iconTarget.textContent = theme === 'dark' ? '☀️' : '🌙'
        }
    }
}
