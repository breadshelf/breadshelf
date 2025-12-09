require 'test_helper'

module Public
  class InformationControllerTest < ActionDispatch::IntegrationTest
    class AboutTests < InformationControllerTest
      test 'displays about page' do
        get '/about'

        assert_dom 'h1', 'about breadshelf'
      end
    end
  end
end
