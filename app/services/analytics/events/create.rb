module Analytics
  class Events::Create < ApplicationService
    def initialize(event, subject)
      @event = event
      @subject = subject
    end

    def call
      Event.create!(event: @event, subject: @subject)
    rescue StandardError
      # Monitoring event
      # Cannot prevent real functionality
    end
  end
end
