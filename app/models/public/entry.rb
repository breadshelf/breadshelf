module Public
  class Entry < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :anonymous_user, optional: true
    belongs_to :book

    validates :user_id, :anonymous_user_id, presence: false
    validate :owner_presence

    def owner
      user || anonymous_user
    end

    private

    def owner_presence
      if user_id.blank? && anonymous_user_id.blank?
        errors.add(:base, 'Entry must belong to either a user or an anonymous user')
      elsif user_id.present? && anonymous_user_id.present?
        errors.add(:base, 'Entry cannot belong to both a user and an anonymous user')
      end
    end
  end
end
