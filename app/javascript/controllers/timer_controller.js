import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["start"]
  static values = { updateUrl: String }

  connect() {
    this.seconds = 0
    this.interval = null
  }

  disconnect() {
    this.#stop()
  }

  start() {
    fetch(this.updateUrlValue, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({})
    })

    this.startTarget.disabled = true
    this.element.querySelector('.read__circle').classList.add('read__circle--running')
    this.interval = setInterval(() => this.#tick(), 1000)
  }

  #tick() {
    this.seconds++
  }

  #stop() {
    if (this.interval) {
      clearInterval(this.interval)
      this.interval = null
    }
  }
}
