
module Analytics
  class Events::SignIn < Events::Create
    def initialize(subject)
      super(Event::EventName::SIGN_IN, subject)
    end
  end
end
