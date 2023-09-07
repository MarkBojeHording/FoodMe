import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="upload"
export default class extends Controller {
  static targets = ["button", "loader", "message"];

  connect() {
    console.log(this.buttonTarget)
  }

  changed() {
    this.buttonTarget.classList.toggle("d-none");
  }

  clicked() {
    console.log(this.loaderTarget);
    this.loaderTarget.classList.toggle("d-none");
    this.buttonTarget.classList.toggle("d-none");
    console.log(this.messageTarget);

    setTimeout(() => {this.messageTarget.innerHTML = "<p data-notification-subscription-target='message' class='message-style fade-in'>Your menu has been stolen by AI!</p>"}, 10000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p data-notification-subscription-target='message' class='message-style fade-in'>Our Burger-Boi is fighting the AI 🤜😈</p>"}, 15000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p data-notification-subscription-target='message' class='message-style fade-in'>Oooh, we found the Icecream 🤤🍦</p>"}, 20000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p data-notification-subscription-target='message' class='message-style fade-in'>...We're almost there! I can taste it...</p>"}, 25000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p data-notification-subscription-target='message' class='message-style fade-in'>Damn! This is one big menu?!</p>"}, 30000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p data-notification-subscription-target='message' class='message-style fade-in'>K.O. Burger-Boi vs AI 😵</p>"}, 35000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p data-notification-subscription-target='message' class='message-style fade-in'>Okay... We're experiencing a few difficulties...</p>"}, 40000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p data-notification-subscription-target='message' class='message-style fade-in'>Eurika! We've sorted that out. Almost there 😁</p>"}, 45000);

  }
}
