module Public
  module Books
    class FindOrCreate < ApplicationService
      def initialize(title)
        @title = title
      end

      def call
        Book.find_or_create_by(title: @title)
      end
    end
  end
end
