require 'test_helper'

module Public
  class EmailBounceTest < ActionDispatch::IntegrationTest
    test 'successful bounce' do
      Public::Emails::Postmark::Suppressor.expects(:call).once.returns(true)

      post '/api/email_bounce', params: { 'RecordType' => 'Bounce', 'Email' => 'test@email.com' }, as: :json
      assert_response :ok
    end

    test 'bounce with error' do
      Public::Emails::Postmark::Suppressor.expects(:call).once.raises(StandardError.new('Test error'))

      post '/api/email_bounce', params: { 'RecordType' => 'Bounce', 'Email' => 'test@email.com' }, as: :json
      assert_response :internal_server_error
    end
  end

  class EmailComplainTest < ActionDispatch::IntegrationTest
    test 'successful complaint' do
      Public::Emails::Postmark::Suppressor.expects(:call).once.returns(true)

      post '/api/email_complaint', params: { 'RecordType' => 'Complaint', 'Email' => 'test@email.com' }, as: :json
      assert_response :ok
    end

    test 'complaint with error' do
      Public::Emails::Postmark::Suppressor.expects(:call).once.raises(StandardError.new('Test error'))

      post '/api/email_complaint', params: { 'RecordType' => 'Complaint', 'Email' => 'test@email.com' }, as: :json
      assert_response :internal_server_error
    end
  end
end
