module Analytics
  class Events::Create < ApplicationService
    def initialize(event, subject)
      @event = event
      @subject = subject
    end

    def call
      Event.create!(event: @event, subject: @subject)
    rescue StandardError => e
      logger.error('Analytics::Events::Create - Failed to create event: ' + e.message)
    end
  end
end
