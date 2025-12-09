
module Public
  class InformationController < ApplicationController
    def about
      Analytics::Events::PageView.call(request.path)
    end
  end
end
