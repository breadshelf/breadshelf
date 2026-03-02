require 'test_helper'

module Public
  class AnonymousUserTest < ActiveSupport::TestCase
    test 'anonymous user can be created' do
      user = AnonymousUser.create!
      assert user.persisted?
      assert user.id.present?
    end

    test 'anonymous user has many entries' do
      anon_user = AnonymousUser.create!
      book = Book.create!(title: 'Test Book')
      entry = Entry.create!(book: book, anonymous_user: anon_user)

      assert_equal [entry], anon_user.entries
    end

    test 'anonymous user entries are destroyed when user is destroyed' do
      anon_user = AnonymousUser.create!
      book = Book.create!(title: 'Test Book')
      Entry.create!(book: book, anonymous_user: anon_user)

      anon_user.destroy
      assert AnonymousUser.find_by(id: anon_user.id).nil?
    end
  end
end
