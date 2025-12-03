require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test 'result only includes clerk publishable key' do
    ENV['CLERK_PUBLISHABLE_KEY'] = 'test-key'

    get '/api/vars'

    result = JSON.parse(response.body)

    assert_equal(result.values.length, 1)
    assert_equal(result['clerkPublishableKey'], 'test-key')
  end
end
