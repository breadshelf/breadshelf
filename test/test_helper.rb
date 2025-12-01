ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'clerk_test_helper'
require 'mocha/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include ClerkTestHelper

    teardown do
      # Clean up clerk override after each test
      ApplicationController.class_eval do
        if @clerk_override
          remove_method(:clerk)
        end
      end
      @clerk_override = false
    end
  end
end
