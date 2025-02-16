import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="notification-subscription"
export default class extends Controller {
  static values = { userId: Number }
  static targets = ["message", "burger", "form", "spinner"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "NotificationChannel", id: this.userIdValue },
      { received: (data) => {
          // console.log(data)
          this.messageTarget.outerHTML = `<p data-notification-subscription-target="message" class='message-style fade-in'>${data.message}</p>`
          // console.log(this.messageTarget)
          this.formTarget.classList.add('d-none')
          if (data.burgerShow) {
            this.burgerTarget.classList.remove('d-none')
            this.spinnerTarget.classList.add('d-none')
          }
      } }
    )
    console.log(`Subscribe to the notification channel`)
  }
}
