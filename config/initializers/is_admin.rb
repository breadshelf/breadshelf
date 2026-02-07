
class IsAdmin
  def self.matches?(request)
    clerk = request.env['clerk']
    return false unless clerk&.user && ENV['ADMIN_EMAIL'].present?

    email_address = clerk.user.email_addresses&.first&.email_address

    email_address == ENV['ADMIN_EMAIL']
  end
end
