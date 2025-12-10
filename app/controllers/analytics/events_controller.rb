
module Analytics
  class EventsController < AdminController
    def index
      @total_events = Analytics::Event.count
      @page_views = Analytics::Event.where(event: Event::EventName::PAGE_VIEW)
      @page_view_counts = {}
      @page_views.distinct(:subject).pluck(:subject).each do |subject|
        @page_view_counts[subject] ||= @page_views.where(subject: subject).count
      end
      @sign_in_count = Analytics::Event.where(event: Event::EventName::SIGN_IN).count
      @sign_up_count = Analytics::Event.where(event: Event::EventName::SIGN_UP).count
    end
  end
end
