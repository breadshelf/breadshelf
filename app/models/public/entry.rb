module Public
  class Entry < ApplicationRecord
    belongs_to :user
    belongs_to :book
    has_many :notes, class_name: 'Public::Note'

    validates :user_id, presence: true

    def owner
      user
    end
  end
end
