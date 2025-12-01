require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test 'result only includes clerk publishable key' do
    ENV['CLERK_PUBLISHABLE_KEY'] = 'test-key'

    get '/api/vars'

    result = JSON.parse(response.body)

    assert(result.values.length == 1)
    assert(result['clerkPublishableKey'] == 'test-key')
  end
end
