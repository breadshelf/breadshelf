
module Public
  class ApiController < ApplicationController
    def deliverability_event
      Rails.logger.info("Deliverability Event Received: #{request.body}")
      head :ok
    end

    private

    def deliverability_event_params
      params.permit
    end
  end
end
