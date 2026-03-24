import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { finishUrl: String }

    async submit(event) {
        console.log('submitting')
        event.preventDefault()
        const csrf = document.querySelector('meta[name="csrf-token"]').content

        await fetch(event.target.action, {
            method: 'POST',
            headers: { 'X-CSRF-Token': csrf },
            body: new FormData(event.target)
        })

        console.log('before finish response', this.finishUrlValue)
        const finishResponse = await fetch(this.finishUrlValue, {
            method: 'PATCH',
            headers: { 'X-CSRF-Token': csrf, 'Content-Type': 'application/json' }
        })

        Turbo.visit(finishResponse.url)
    }
}
