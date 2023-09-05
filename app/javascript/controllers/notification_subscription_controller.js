import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="notification-subscription"
export default class extends Controller {
  static values = { userId: Number }
  static targets = ["message"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "NotificationChannel", id: this.userIdValue },
      { received: (data) => {
          console.log(data)
          this.messageTarget.innerText = data
      } }
    )
    console.log(`Subscribe to the notification channel`)
  }
}
