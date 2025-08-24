class SigninsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create, :update ]

  # GET /signin/new
  def new
  end

  # POST /sigin
  def create
    @registration = Registration.new(registration_params)

    if @registration.save
      redirect_to @registration, notice: "Registration was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /signin
  def update
    if @registration.update(registration_params)
      redirect_to @registration, notice: "Registration was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def registration_params
      params.fetch(:registration, {})
    end
end
