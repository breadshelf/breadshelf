
module Analytics
  class Event < ApplicationRecord
    self.table_name = 'analytics.events'

    module EventName
      SIGN_UP = 'sign_up'
      SIGN_IN = 'sign_in'
      PAGE_VIEW = 'page_view'
    end
  end
end
