// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import { Idiomorph } from "idiomorph"
import "controllers"

Turbo.StreamActions.morph = function() {
  this.targetElements.forEach((element) => {
    Idiomorph.morph(element, this.templateContent)
    element.dispatchEvent(new CustomEvent('turbo:morph', { bubbles: true }))
  })
}
