import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="registration"
export default class extends Controller {
  connect() {
  }

  async callback(event) {
    event.preventDefault();
    const formData = new FormData(this.element);

    const response = await fetch(
      this.element.action,
      { method: this.element.method, body: formData});

    if (response.ok) {
      const data = await response.json();
      console.log(data);
      const credential = await navigator.credentials.create(data);
      debugger;
    } else {
      const errorData = await response.json();
      console.error("Error:", errorData);
      console.error("Error submitting form");
    }
  }
}
