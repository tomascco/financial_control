import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails";
import { post } from "@rails/request.js"

// Connects to data-controller="authentication"
export default class extends Controller {
  static values = { sessionUrl: String, callbackUrl: String }

  connect() {
  }

  async callback(event) {
    event.preventDefault();

    const sessionRequest = await post(this.sessionUrlValue, { method: "POST" });
    if (!sessionRequest.ok) {
      const errorData = await sessionRequest.json;
      console.error("Error:", errorData);
      console.error("Error initiating authentication");
    }

    const challengeData = await sessionRequest.json;
    const credentialOptions = PublicKeyCredential.parseRequestOptionsFromJSON(challengeData);
    const credential = await navigator.credentials.get({ publicKey: credentialOptions });

    const authenticationResult = await post(this.callbackUrlValue, { body: JSON.stringify(credential) });
    if (!authenticationResult.ok) {
      const errorData = await authenticationResult.text;
      console.error("Error:", errorData);
      console.error("Error completing authentication");
    }

    Turbo.visit("/");
  }
}
