module Public
  class Entry < ApplicationRecord
    belongs_to :user
    belongs_to :book
  end
end
