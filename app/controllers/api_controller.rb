
class ApiController < ApplicationController
  def vars
    render json: { clerk_publishable_key: ENV['CLERK_PUBLISHABLE_KEY'] }
  end
end
