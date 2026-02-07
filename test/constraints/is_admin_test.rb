require 'test_helper'

class IsAdminTest < ActiveSupport::TestCase
  setup do
    @admin_email = 'admin@example.com'
    ENV['ADMIN_EMAIL'] = @admin_email
  end

  test 'matches? returns true when user email matches admin email' do
    clerk = OpenStruct.new(
      user: OpenStruct.new(
        email_addresses: [
          OpenStruct.new(email_address: @admin_email)
        ]
      )
    )

    request = OpenStruct.new(env: { 'clerk' => clerk })

    assert IsAdmin.matches?(request)
  end

  test 'matches? returns false when user email does not match admin email' do
    clerk = OpenStruct.new(
      user: OpenStruct.new(
        email_addresses: [
          OpenStruct.new(email_address: 'user@example.com')
        ]
      )
    )

    request = OpenStruct.new(env: { 'clerk' => clerk })

    refute IsAdmin.matches?(request)
  end

  test 'matches? returns false when clerk is nil' do
    request = OpenStruct.new(env: {})

    refute IsAdmin.matches?(request)
  end

  test 'matches? returns false when user is nil' do
    clerk = OpenStruct.new(user: nil)
    request = OpenStruct.new(env: { 'clerk' => clerk })

    refute IsAdmin.matches?(request)
  end

  test 'matches? returns false when email_addresses is empty' do
    clerk = OpenStruct.new(
      user: OpenStruct.new(email_addresses: [])
    )
    request = OpenStruct.new(env: { 'clerk' => clerk })

    refute IsAdmin.matches?(request)
  end

  test 'matches? returns false when ADMIN_EMAIL is not set' do
    ENV['ADMIN_EMAIL'] = nil

    clerk = OpenStruct.new(
      user: OpenStruct.new(
        email_addresses: [
          OpenStruct.new(email_address: 'admin@example.com')
        ]
      )
    )
    request = OpenStruct.new(env: { 'clerk' => clerk })

    refute IsAdmin.matches?(request)
  end

  test 'matches? returns false when user and ADMIN_EMAIL are both nil' do
    ENV['ADMIN_EMAIL'] = nil

    clerk = OpenStruct.new(
      user: OpenStruct.new(email_addresses: [])
    )
    request = OpenStruct.new(env: { 'clerk' => clerk })

    refute IsAdmin.matches?(request)
  end
end
