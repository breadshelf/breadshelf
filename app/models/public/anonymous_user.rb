module Public
  class AnonymousUser < ApplicationRecord
    has_many :entries, foreign_key: :anonymous_user_id, dependent: :destroy
  end
end
