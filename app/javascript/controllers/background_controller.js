import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    theme: String,
    assetVersion: String
  }

  connect() {
    this.updateBackground()
  }

  updateBackground() {
    if (this.themeValue && this.themeValue !== 'default') {
      const backgroundElement = document.querySelector('.split-container') || document.body
      backgroundElement.style.backgroundImage = `url(${this.assetPath()})`
      backgroundElement.style.backgroundSize = 'cover'
      backgroundElement.style.backgroundPosition = 'center'
    }
  }

  assetPath() {
    return this.element.dataset[`${this.themeValue}AssetUrl`]
  }
}