
module Public
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:email_bounce, :email_complaint]

    def email_bounce
      Rails.logger.info('Email Bounce Event Received')
      raw_json = request.body.read
      json = JSON.parse(raw_json)


      Public::Emails::Postmark::Suppressor.call(json)
      head :ok
    rescue StandardError => e
      Rails.logger.error("Error processing email bounce event: #{e.message}")
      head :internal_server_error
    end

    def email_complaint
      Rails.logger.info('Email Complaint Event Received')
      raw_json = request.body.read
      json = JSON.parse(raw_json)

      Public::Emails::Postmark::Suppressor.call(json)
      head :ok
    rescue StandardError => e
      Rails.logger.error("Error processing email complaint event: #{e.message}")
      head :internal_server_error
    end
  end
end
