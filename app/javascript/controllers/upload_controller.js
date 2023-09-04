import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="upload"
export default class extends Controller {
  static targets = ["button", "loader"];

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
  }
}
