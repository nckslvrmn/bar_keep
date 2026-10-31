import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["query", "status", "results", "selection", "file"]
    static values = { url: String }

    async search() {
        if (!this.queryTarget.value.trim()) {
            this.queryTarget.value = this.defaultQuery
        }

        const query = this.queryTarget.value.trim()
        if (!query) {
            this.statusTarget.textContent = "Enter a name or a search term first."
            return
        }

        this.statusTarget.textContent = "Searching..."
        this.resultsTarget.replaceChildren()
        this.abortController?.abort()
        this.abortController = new AbortController()

        try {
            const response = await fetch(`${this.urlValue}?${new URLSearchParams({ q: query })}`, {
                headers: { Accept: "application/json" },
                signal: this.abortController.signal
            })
            if (!response.ok) throw new Error(response.statusText)

            const results = await response.json()
            this.resultsTarget.replaceChildren(...results.map(result => this.resultButton(result)))
            this.statusTarget.textContent = results.length ? "Pick an image to use it." : "No images found."
        } catch (error) {
            if (error.name === "AbortError") return
            this.statusTarget.textContent = "Image search failed. Try again or upload a file."
        }
    }

    disconnect() {
        this.abortController?.abort()
    }

    select({ currentTarget, params: { imageUrl, thumbnailUrl } }) {
        this.clearSelection()
        this.fileTarget.value = ""
        currentTarget.classList.add("active")
        currentTarget.setAttribute("aria-pressed", true)

        // The thumbnail is a fallback for originals the server cannot download.
        for (const url of [imageUrl, thumbnailUrl]) {
            const input = document.createElement("input")
            input.type = "hidden"
            input.name = "item[image_urls][]"
            input.value = url
            this.selectionTarget.append(input)
        }
        this.statusTarget.textContent = "The selected image is saved with the item."
    }

    clearSelection() {
        this.selectionTarget.replaceChildren()
        this.resultsTarget.querySelectorAll(".active").forEach(button => {
            button.classList.remove("active")
            button.setAttribute("aria-pressed", false)
        })
    }

    resultButton({ title, thumbnail_url, image_url }) {
        const button = document.createElement("button")
        button.type = "button"
        button.className = "image-search-result"
        button.title = title
        button.setAttribute("aria-pressed", false)
        button.dataset.action = "image-search#select"
        button.dataset.imageSearchImageUrlParam = image_url
        button.dataset.imageSearchThumbnailUrlParam = thumbnail_url
        button.hidden = true

        const image = document.createElement("img")
        image.addEventListener("load", () => button.hidden = false, { once: true })
        image.addEventListener("error", () => this.removeResult(button), { once: true })
        image.alt = title
        image.referrerPolicy = "no-referrer"
        image.src = thumbnail_url
        button.append(image)

        return button
    }

    removeResult(button) {
        button.remove()
        if (!this.resultsTarget.children.length) {
            this.statusTarget.textContent = "No images found."
        }
    }

    get defaultQuery() {
        const form = this.element.closest("form")
        const name = form.elements["item[name]"]?.value ?? ""
        const categories = (form.elements["item[category_names]"]?.value ?? "").split(",")
        return [name, ...categories].map(term => term.trim()).filter(Boolean).join(" ")
    }
}
