import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails";
import { post } from "@rails/request.js"

// Connects to data-controller="registration"
export default class extends Controller {
  static values = { callbackUrl: String }

  connect() {
  }

  async callback(event) {
    event.preventDefault();

    const formData = new FormData(this.element);
    const response = await post(this.element.action, { body: formData});

    if (!response.ok) {
      const errorData = await response.json;
      console.error("Error:", errorData);
      console.error("Error submitting form");
    }

    const requestData = await response.json;
    const credentialOptions = PublicKeyCredential.parseCreationOptionsFromJSON(requestData);

    const credential = await navigator.credentials.create({ publicKey: credentialOptions });

    const result = await post(
      this.callbackUrlValue,
      { method: "POST", body: JSON.stringify(credential)});

    if (!result.ok) {
      const errorData = await result.text;
      console.error("Error:", errorData);
      console.error("Error completing registration");
    }


    Turbo.visit("/");
  }
}
