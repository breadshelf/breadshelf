require 'digest'

module Analytics
  class Events::SignIn < Events::Create
    def initialize(subject)
      super(Event::EventName::SIGN_IN, Digest::SHA256.hexdigest(subject))
    end
  end
end
