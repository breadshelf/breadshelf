class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  before_create :assign_uuid_primary_key

  private

  def assign_uuid_primary_key
    if self.class.primary_key && self[self.class.primary_key].nil?
      self[self.class.primary_key] = SecureRandom.uuid_v7
    end
  end
end
