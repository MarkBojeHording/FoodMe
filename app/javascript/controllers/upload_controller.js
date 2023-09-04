import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="upload"
export default class extends Controller {
  static targets = ["button"];

  connect() {
    console.log(this.buttonTarget)
  }

  changed() {
    this.buttonTarget.classList.toggle("d-none");
  }
}
