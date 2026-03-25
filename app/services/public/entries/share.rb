module Public
  module Entries
    class Share < ApplicationService
      def initialize(entry:)
        @entry = entry
      end

      def call
        puts "NOAHTEST #{@entry.inspect}"
        return @entry if @entry.shared

        puts "NOAHTEST UPDATING"
        @entry.update!(crumbs: @entry.crumbs + 1, shared: true)
        @entry
      end
    end
  end
end
