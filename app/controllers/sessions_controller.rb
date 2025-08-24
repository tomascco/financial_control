class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    if Current.user
      redirect_to after_authentication_url, notice: "You are already signed in."
    else
      render :new
    end
  end

  def create
    get_options = WebAuthn::Credential.options_for_get(user_verification: "required")

    session[:current_authentication] = { challenge: get_options.challenge }

    render json: get_options
  end

  def callback
    webauthn_credential = ::WebAuthn::Credential.from_get(params)

    credential = Credential.find_by(external_id: webauthn_credential.id)
    render json: "Could not find a user for this Passkey", status: :not_found and return unless credential

    webauthn_credential.verify(
      session.dig(:current_authentication, "challenge"),
      public_key: credential.public_key,
      sign_count: credential.sign_count,
      user_verification: true
    )

    credential.update!(sign_count: webauthn_credential.sign_count)

    start_new_session_for(credential.user)

    head :created
  rescue ::WebAuthn::Error => e
    render json: "Verification failed: #{e.message}", status: :unprocessable_content
  ensure
    session.delete(:current_authentication)
  end

  def destroy
    terminate_session

    redirect_to new_session_url, notice: "You have been signed out."
  end
end
