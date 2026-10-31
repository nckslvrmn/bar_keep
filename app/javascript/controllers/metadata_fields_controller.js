import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["fields", "dialog", "name", "template"]

    open() {
        this.nameTarget.value = ""
        this.nameTarget.classList.remove("is-invalid")
        this.dialogTarget.showModal()
    }

    close() {
        this.dialogTarget.close()
    }

    add() {
        const key = this.nameTarget.value.trim()
        if (!key) {
            this.nameTarget.classList.add("is-invalid")
            this.nameTarget.focus()
            return
        }

        const field = this.templateTarget.content.firstElementChild.cloneNode(true)
        const input = field.querySelector("input")
        field.querySelector("label").textContent = key
        input.name = `metadata[${key.toLowerCase().replace(/\s+/g, "_")}]`
        input.placeholder = key
        this.fieldsTarget.append(field)

        this.close()
        field.scrollIntoView({ behavior: "smooth", block: "nearest" })
    }
}
