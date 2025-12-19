
module Public
  class UserSetting < ApplicationRecord
    belongs_to :user, class_name: 'Public::User'
    belongs_to :setting, class_name: 'Public::Setting'

    validates :user_id, presence: true
    validates :setting_id, presence: true
    validates :enabled, inclusion: { in: [true, false] }

  end
end