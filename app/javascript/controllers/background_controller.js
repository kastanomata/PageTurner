import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { theme: String }

  connect() {
    this.updateBackground()
  }

  updateBackground() {
    document.body.style.backgroundImage = `url(${this.assetPath(this.themeValue)})`
  }

  assetPath(filename) {
    return `/assets/${filename}-<%= Rails.application.config.assets.version %>.jpg`
  }
}