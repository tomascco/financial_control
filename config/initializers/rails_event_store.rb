# frozen_string_literal: true

require "application_event_store"

Rails.configuration.to_prepare do
  Rails.configuration.event_store = ApplicationEventStore.new
  # add subscribers here
end
