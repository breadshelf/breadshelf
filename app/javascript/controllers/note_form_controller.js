import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { finishUrl: String }

    async submit(event) {
        event.preventDefault()
        const csrf = document.querySelector('meta[name="csrf-token"]').content

        await fetch(event.target.action, {
            method: 'POST',
            headers: { 'X-CSRF-Token': csrf },
            body: new FormData(event.target)
        })

        const finishedBook = document.getElementById('finished_book')?.checked ?? false

        const finishResponse = await fetch(this.finishUrlValue, {
            method: 'PATCH',
            headers: { 'X-CSRF-Token': csrf, 'Content-Type': 'application/json' },
            body: JSON.stringify({ finished_book: finishedBook })
        })

        Turbo.visit(finishResponse.url)
    }
}
