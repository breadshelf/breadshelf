
class AuthController < ApplicationController
  def sign_in
    redirect_to(ENV.fetch('CLERK_FRONTEND_URL') + '/sign-in', allow_other_host: true)
  end
end
