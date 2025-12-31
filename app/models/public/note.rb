module Public
  class Note < ApplicationRecord
    belongs_to :entry
  end
end
