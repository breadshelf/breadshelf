class ApplicationService
  class InternalServiceError < StandardError; end

  include ActiveModel::Model

  def self.execute(*args)
    new(*args).execute
  end

  def self.call(...)
    new(...).call
  end
end
