require 'digest'

module Analytics
  class Events::SignUp < Events::Create
    def initialize(subject)
      super(Event::EventName::SIGN_UP,  Digest::SHA256.hexdigest(subject))
    end
  end
end
