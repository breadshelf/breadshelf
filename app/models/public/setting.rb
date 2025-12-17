
module Public
  class Setting < ApplicationRecord
    has_many :user_settings, class_name: 'Public::UserSetting', dependent: :destroy
    has_many :users, through: :user_settings, class_name: 'Public::User'

    validates :name, presence: true, uniqueness: true

    module Name
      ALLOW_EMAILS = 'allow_emails'
    end
  end
end