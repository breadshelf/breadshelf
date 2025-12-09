
module Analytics
  class Events::SignUp < Events::Create
    def initialize(subject)
      super(Event::EventName::SIGN_UP, subject)
    end
  end
end
