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

    setTimeout(() => {this.messageTarget.innerHTML = "<p class='message-style'>-->Your menu has been stolen by AI!<--</p>"}, 10000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p class='message-style'>-->Our Burger-Boi is fighting the AI 🤜😈<--</p>"}, 15000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p class='message-style'>-->Oooh, we found the Icecream 🤤🍦<--</p>"}, 20000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p class='message-style'>-->...We're almost there! I can taste it...<--</p>"}, 25000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p class='message-style'>-->Damn! This is one big menu?!<--</p>"}, 30000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p class='message-style'>-->K.O. Burger-Boi vs AI 😵<--</p>"}, 35000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p class='message-style'>-->Okay... We're experiencing a few difficulties...<--</p>"}, 40000);
    setTimeout(() => {this.messageTarget.innerHTML = "<p class='message-style'>-->Eurika! We've sorted that out. Almost there 😁<--</p>"}, 45000);

  }
}
