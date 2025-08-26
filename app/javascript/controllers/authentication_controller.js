import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails";
import { post } from "@rails/request.js"
import { showToast } from "../toast_manager";

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

      showToast("Error initiating authentication", "error", 1000);
      return;
    }

    const challengeData = await sessionRequest.json;
    const credentialOptions = PublicKeyCredential.parseRequestOptionsFromJSON(challengeData);
    const credential = await navigator.credentials.get({ publicKey: credentialOptions });

    const authenticationResult = await post(this.callbackUrlValue, { body: JSON.stringify(credential) });
    if (!authenticationResult.ok) {
      const errorData = await authenticationResult.text;

      showToast("Error on authentication callback", "error", 1000);
      return;
    }

    Turbo.visit("/");
  }
}
