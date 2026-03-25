import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["count", "breakdown", "readingCount", "noteCount", "share", "shareCanvas", "copyConfirmation"]
    static values = { total: Number, reading: Number, note: Number, particleSrc: String, readingMinutes: Number, bookTitle: String, entryId: String, shared: Boolean }

    connect() {
        this.#launchParticles()
        this.#animateCount()
    }

    async share({ params: { shareText } }) {
        const canvas = this.shareCanvasTarget
        canvas.width = 1080
        canvas.height = 1080
        const ctx = canvas.getContext('2d')

        ctx.fillStyle = '#1a1a2e'
        ctx.fillRect(0, 0, 1080, 1080)

        ctx.fillStyle = '#ffffff'
        ctx.font = 'bold 72px sans-serif'
        ctx.textAlign = 'center'
        this.#wrapText(ctx, this.bookTitleValue, 540, 280, 900, 90)

        ctx.fillStyle = '#e040fb'
        ctx.font = 'bold 160px sans-serif'
        ctx.fillText(this.totalValue, 540, 560)

        ctx.fillStyle = '#ffffff'
        ctx.font = '52px sans-serif'
        ctx.fillText('crumbs earned', 540, 640)

        ctx.font = '44px sans-serif'
        ctx.fillStyle = '#aaaaaa'
        const mins = this.readingMinutesValue
        ctx.fillText(`${mins} minute${mins !== 1 ? 's' : ''} read`, 540, 730)

        ctx.fillStyle = '#e040fb'
        ctx.font = 'bold 40px sans-serif'
        ctx.fillText('Breadshelf', 540, 980)

        const blob = await new Promise(resolve => canvas.toBlob(resolve, 'image/png'))
        const file = new File([blob], 'breadshelf.png', { type: 'image/png' })

        let shared = false
        if (navigator.share) {
            try {
                if (navigator.canShare?.({ files: [file] })) {
                    await navigator.share({ files: [file], text: shareText })
                } else {
                    await navigator.share({ text: shareText })
                }
                shared = true
            } catch (e) {
                if (e.name !== 'AbortError') throw e
            }
        } else {
            await navigator.clipboard.writeText(shareText)
            this.#showCopyConfirmation()
            shared = true
        }

        if (shared) {
            this.#awardShareCrumb()
        }
    }

    #awardShareCrumb() {
        const entryId = this.entryIdValue
        fetch(`/entries/${entryId}/share`, {
            method: 'POST',
            headers: { 'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content }
        })
        if (!this.sharedValue) {
            this.#animateBonusCrumb()
        }
        this.sharedValue = true
    }

    #showCopyConfirmation() {
        this.copyConfirmationTarget.hidden = false
        setTimeout(() => { this.copyConfirmationTarget.hidden = true }, 5000)
    }

    #animateBonusCrumb() {
        const start = this.totalValue
        const target = start + 1
        const duration = 400
        const startTime = performance.now()

        const step = (now) => {
            const progress = Math.min((now - startTime) / duration, 1)
            const eased = 1 - Math.pow(1 - progress, 3)
            this.countTarget.textContent = Math.floor(start + eased)
            if (progress < 1) {
                requestAnimationFrame(step)
            } else {
                this.countTarget.textContent = target
            }
        }

        requestAnimationFrame(step)
    }

    #wrapText(ctx, text, x, y, maxWidth, lineHeight) {
        const words = text.split(' ')
        let line = ''
        for (const word of words) {
            const test = line ? `${line} ${word}` : word
            if (ctx.measureText(test).width > maxWidth && line) {
                ctx.fillText(line, x, y)
                line = word
                y += lineHeight
            } else {
                line = test
            }
        }
        ctx.fillText(line, x, y)
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
