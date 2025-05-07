import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["timer"]
  static values = { expiresAt: String }

  connect() {
    console.log('Countdown initialized for:', this.expiresAtValue)
    this.endTime = new Date(this.expiresAtValue)
    this.updateTimer()
    this.timerInterval = setInterval(() => this.updateTimer(), 1000)
  }

  updateTimer() {
    const now = new Date()
    const distance = this.endTime - now

    if (distance < 0) {
      this.handleExpiration()
      this.timerTarget.innerHTML = 'Voting closed <i class="bi bi-lock"></i>'
      this.element.classList.add('poll-expired')
      clearInterval(this.timerInterval)
      return
    }

    const days = Math.floor(distance / (1000 * 60 * 60 * 24))
    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60))
    const seconds = Math.floor((distance % (1000 * 60)) / 1000)

    this.timerTarget.innerHTML = `
      <span class="time-segment">${days.toString().padStart(2, '0')}d</span>
      <span class="time-segment">${hours.toString().padStart(2, '0')}h</span>
      <span class="time-segment">${minutes.toString().padStart(2, '0')}m</span>
      <span class="time-segment">${seconds.toString().padStart(2, '0')}s</span>
    `
  }

  handleExpiration() {
    this.element.classList.add('poll-expired')
    this.voteButtonTargets.forEach(button => {
      button.disabled = true
      button.classList.replace('btn-primary', 'btn-secondary')
      button.textContent = 'Voting Closed'
    })
  }

  disconnect() {
    clearInterval(this.timerInterval)
  }
}