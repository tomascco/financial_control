# frozen_string_literal: true

class ApplicationEventStore < RailsEventStore::JSONClient
  def publish(events, ...)
    if events.is_a?(Array)
      events.each { |event| validate_mandatory_keys(event) }
    else
      validate_mandatory_keys(events)
    end

    super
  end

  def validate_mandatory_keys(event)
    metadata_keys = event.data.keys
    mandatory_keys = event.mandatory_keys

    missing_keys = mandatory_keys - metadata_keys
    raise "#{event.class} is missing mandatory keys: #{missing_keys.join(', ')}" unless missing_keys.empty?
  end
end
