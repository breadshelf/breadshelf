
module Public
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:deliverability_event]

    def deliverability_event
      Rails.logger.info("Deliverability Event Received: #{request.body.read}")

      raw_json = request.body.read
      json = JSON.parse(raw_json)

      Public::Emails::Suppressor.call(json)
      head :ok
    rescue
      head :internal_server_error
    end

    private

    # def deliverability_event_params
    #   params.permit
    # end
  end
end
