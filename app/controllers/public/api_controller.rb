
module Public
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:deliverability_event]

    def deliverability_event
      Rails.logger.info("Deliverability Event Received: #{request.body.read}")
      Rails.logger.info("Deliverability Event Params: #{params.inspect}")
      head :ok
    end

    private

    # def deliverability_event_params
    #   params.permit
    # end
  end
end
