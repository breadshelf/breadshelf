require 'test_helper'

module Public
  class ApiControllerTest < ActionDispatch::IntegrationTest
    test 'deliverability event logs the event and responds with ok' do
      Public::Emails::Suppressor.expects(:call).once.returns(true)
      post '/api/deliverability_event', params: { event: 'bounce', email: 'help@email.com' }, as: :json
      assert_response :ok
    end
  end
end
