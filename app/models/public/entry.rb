module Public
  class Entry < ApplicationRecord
    belongs_to :user
    belongs_to :book

    validates :user_id, presence: true

    def owner
      user
    end
  end
end
