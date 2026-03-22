module Public
  module Books
    class FindOrCreate < ApplicationService
      def initialize(title, author: nil)
        @title = title.downcase.strip
        @author = author.downcase.strip if author.present?

        raise(ArgumentError, 'Title must exist') unless @title
      end

      def call
        Book.find_or_create_by(title: @title, author: @author)
      end
    end
  end
end
