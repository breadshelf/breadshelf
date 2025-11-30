
module ClerkTestHelper
  def setup_clerk(user_exists: false, user_attrs: {}, clerk_attrs: {})
    @clerk_override = true

    if user_exists
      default_user_attrs = {
        id: 'user_123',
        email_addresses: [stub(email_address: 'test@example.com')],
        first_name: 'Test',
        last_name: 'User'
      }
      mock_user = stub(default_user_attrs.merge(user_attrs))

      default_clerk_attrs = {
        user?: true,
        user: mock_user,
        id: 'clerk_123'
      }
      mock_clerk = stub(default_clerk_attrs.merge(clerk_attrs))
    else
      mock_clerk = stub(user?: false, user: nil)
    end

    ApplicationController.class_eval do
      define_method(:clerk) { mock_clerk }
    end
  end

  def clerk_sign_in(user_attrs: {}, clerk_attrs: {})
    setup_clerk(user_exists: true, user_attrs: user_attrs, clerk_attrs: clerk_attrs)
  end

  def clerk_sign_out
    setup_clerk(user_exists: false)
  end
end
