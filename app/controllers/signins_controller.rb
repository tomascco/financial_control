class SigninsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create, :update ]

  # GET /signin/new
  def new
    render :new, locals: { user: User.new }
  end

  # POST /sigin
  def create
    user = User.new(user_params)

    create_options = ::WebAuthn::Credential.options_for_create(
      user: { id: user.webauthn_id, name: user.name },
      authenticator_selection: { user_verification: "required" },
    )

    if user.valid?
      session[:current_registration] = { user: user.attributes, create_options: create_options }
      render json: create_options
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_content
    end
  end

  # PATCH/PUT /signin
  def update
    webauthn_credential = ::WebAuthn::Credential.from_create(credential_params)

    user = User.new(session.dig(:current_registration, :user))

    begin
      webauthn_credential.verify(session.dig(:current_registration, :challange), user_verification: true)

      user.credentials.build(
        external_id: webauthn_credential.id,
        nickname: params[:credential_nickname],
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count,
      )

      if user.save
        # sign_in(user)
        # redirect_to root_path, notice: "Welcome, #{user.name}!"
      else
        render json: "Could not save your Passkey. Please, try again.", status: :unprocessable_content
      end
    rescue ::WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_content
    ensure
      session.delete(:current_registration)
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def user_params
    params.expect(user: [ :name, :username ])
  end

  def credential_params
    params.expect(:credential).permit(:id, :raw_id, :response, :type, :client_extension_results)
  end
end
