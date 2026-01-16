
module Public
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:deliverability_event]

    def deliverability_event
      raw_json = request.body.read
      Rails.logger.info("Deliverability Event Received: #{raw_json}")

      json = JSON.parse(raw_json)

      Public::Emails::Suppressor.call(json)
      head :ok
    rescue StandardError => e
      Rails.logger.error("Error processing deliverability event: #{e.message}")
      head :internal_server_error
    end
  end
end
