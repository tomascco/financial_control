# frozen_string_literal: true

class ApplicationEvent < RailsEventStore::Event
  def mandatory_keys
    # fetches the MANDATORY_KEYS constant from the subclass
    self.class::MANDATORY_KEYS
  end
end
