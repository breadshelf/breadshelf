require 'test_helper'

class InformationControllerTest < ActionDispatch::IntegrationTest
  class AboutTests < InformationControllerTest
    test 'displays about page' do
      get '/about'

      assert_dom 'h1', 'about breadshelf'
    end
  end
end
