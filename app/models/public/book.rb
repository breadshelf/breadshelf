module Public
  class Book < ApplicationRecord
    has_many :user_books, class_name: 'Public::UserBook'
    has_many :users, through: :user_books, source: :user
  end
end
