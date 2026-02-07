
module Analytics
  class EventsController < ApplicationController
    def index
      @total_events = Analytics::Event.count
      @page_views = Analytics::Event.where(event: Event::EventName::PAGE_VIEW)
      @page_view_counts = {}
      @page_views.distinct(:subject).pluck(:subject).each do |subject|
        @page_view_counts[subject] ||= @page_views.where(subject: subject).count
      end
      @sign_in_count = Analytics::Event.where(event: Event::EventName::SIGN_IN).count
      @sign_up_count = Analytics::Event.where(event: Event::EventName::SIGN_UP).count

      @daus = calculate_daus
    end

    private

    def calculate_daus
      Analytics::Event
        .where(event: Analytics::Event::EventName::SIGN_IN)
        .where('created_at >= ?', 2.weeks.ago)
        .group(Arel.sql('DATE(created_at)'))
        .select(Arel.sql('DATE(created_at) as date, COUNT(DISTINCT subject) as count'))
        .order(Arel.sql('DATE(created_at) DESC'))
        .map { |record| { date: record.date, count: record.count } }
    end
  end
end
