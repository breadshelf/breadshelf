import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["count", "breakdown", "readingCount", "noteCount", "share"]
    static values = { total: Number, reading: Number, note: Number, particleSrc: String }

    connect() {
        this.#launchParticles()
        this.#animateCount()
    }

    share({ params: { shareText } }) {
        if (navigator.share) {
            navigator.share({ text: shareText })
        } else {
            navigator.clipboard.writeText(shareText)
                .then(() => alert('Copied to clipboard!'))
        }
    }

    #animateCount() {
        const duration = 800
        const start = performance.now()
        const total = this.totalValue

        const step = (now) => {
            const elapsed = now - start
            const progress = Math.min(elapsed / duration, 1)
            const eased = 1 - Math.pow(1 - progress, 3)
            const current = Math.floor(eased * total)

            this.countTarget.textContent = current

            if (progress < 1) {
                requestAnimationFrame(step)
            } else {
                this.countTarget.textContent = total
                this.#revealDetails()
            }
        }

        requestAnimationFrame(step)
    }

    #launchParticles() {
        const count = Math.min(this.totalValue, 10)
        for (let i = 0; i < count; i++) {
            setTimeout(() => this.#createParticle(), i * 100)
        }
    }

    #createParticle() {
        const el = document.createElement('img')
        el.src = this.particleSrcValue
        el.className = 'crumb-particle'
        document.body.appendChild(el)

        let x = window.innerWidth * (0.3 + Math.random() * 0.4)
        let y = window.innerHeight - 30
        let vx = (Math.random() - 0.5) * 10
        let vy = -(14 + Math.random() * 8)
        const gravity = 0.45
        const maxAge = 90
        let age = 0

        const animate = () => {
            age++
            vy += gravity
            x += vx
            y += vy

            const progress = age / maxAge
            const opacity = progress < 0.4 ? 1 : 1 - (progress - 0.4) / 0.6
            const scale = progress < 0.2
                ? 0.4 + (progress / 0.2) * 0.6
                : 1 - (progress - 0.2) / 0.8 * 0.7

            el.style.transform = `translate(${x}px, ${y}px) scale(${scale})`
            el.style.opacity = opacity

            if (age < maxAge) {
                requestAnimationFrame(animate)
            } else {
                el.remove()
            }
        }

        requestAnimationFrame(animate)
    }

    #revealDetails() {
        if (this.hasReadingCountTarget) {
            this.readingCountTarget.textContent = this.readingValue
        }
        if (this.hasNoteCountTarget) {
            this.noteCountTarget.textContent = this.noteValue
        }
        this.breakdownTarget.hidden = false
        this.shareTarget.hidden = false
    }
}
