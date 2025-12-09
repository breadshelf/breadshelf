module Public
  class User < ApplicationRecord
    validates_uniqueness_of(:email)
    validates(:email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' })
  end
end
