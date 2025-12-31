
module Analytics
  class Events::PageView < Events::Create
    def initialize(path)
      super(Analytics::Event::EventName::PAGE_VIEW, path)
    end
  end
end
