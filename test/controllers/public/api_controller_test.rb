require 'test_helper'

module Public
  class ApiControllerTest < ActionDispatch::IntegrationTest
    test 'deliverability event logs the event and responds with ok' do
      post '/api/deliverability_event', params: { event: 'bounce', email: 'help@email.com' }
      assert_response :ok
    end
  end
end
