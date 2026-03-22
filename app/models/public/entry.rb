module Public
  class Entry < ApplicationRecord
    belongs_to :user_book, class_name: 'Public::UserBook'
    has_many :notes, class_name: 'Public::Note'

    validates :user_book, presence: true

    def owner
      user_book.user
    end
  end
end
