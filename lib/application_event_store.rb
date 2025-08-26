# frozen_string_literal: true

class ApplicationEventStore < RailsEventStore::JSONClient
  def publish(event, ...)
    metadata_keys = event.data.keys
    mandatory_keys = event.mandatory_keys

    missing_keys = mandatory_keys - metadata_keys
    raise "#{event.class} is missing mandatory keys: #{missing_keys.join(', ')}" unless missing_keys.empty?

    super
  end

end
