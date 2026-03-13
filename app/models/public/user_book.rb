module Public
  class UserBook < ApplicationRecord
    belongs_to :user, class_name: 'Public::User'
    belongs_to :book, class_name: 'Public::Book'

    validates :user, presence: true
    validates :book, presence: true

    scope :active, -> { where(active: true) }
  end
end
