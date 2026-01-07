
module Public
  class InformationController < ApplicationController
    def about
      Analytics::Events::PageView.call(request.path)
    end

    def privacy_policy
      Analytics::Events::PageView.call(request.path)
    end

    def data_policy
      Analytics::Events::PageView.call(request.path)
    end
  end
end
