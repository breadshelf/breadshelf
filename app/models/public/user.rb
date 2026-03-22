module Public
  class User < ApplicationRecord
    has_many :entries, through: :user_books
    has_many(:user_settings)
    has_many :user_books, class_name: 'Public::UserBook'
    has_many :books, through: :user_books, source: :book

    validates :clerk_id, presence: true, unless: :anonymous?
    validates :email, presence: true, unless: :anonymous?
    validates(:email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }, allow_blank: true)
    validates_uniqueness_of(:email, allow_blank: true)

    def allow_emails?
      return false if anonymous?

      setting = user_settings
        .joins(:setting)
        .find_by(settings: { name: Public::Setting::Name::ALLOW_EMAILS })
      setting.present? ? setting.enabled : true
    end
  end
end
