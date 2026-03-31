
module Public
  class UsersController < ApplicationController
    def landing
      @user_exists = clerk.user?
      Analytics::Events::PageView.call(request.path)
    end

    def sign_in
      created = Public::Users::Create.call(clerk.user)

      email_address = clerk.user&.email_addresses&.first&.email_address
      if created
        Analytics::Events::SignUp.call(email_address)
      else
        Analytics::Events::SignIn.call(email_address)
      end

      render json: {}, status: created ? :created : :ok
    end

    def show
      raise(NotFoundError) if current_user.nil?

      total_crumbs = current_user.entries.sum(:crumbs)
      @loaves = total_crumbs / 144
      @slices = (total_crumbs % 144) / 12
      @crumbs = total_crumbs % 12
      @user_books = current_user.user_books.active.includes(:book)

      @last_note_ids = @user_books.each_with_object({}) do |user_book, hash|
        last_entry = Entry.where(user_book: user_book).order(:created_at).last
        hash[user_book.id] = last_entry&.notes&.last&.id
      end
    end

    def settings
      raise(NotFoundError) if current_user.nil?

      @user_settings = {
        allow_emails: current_user.allow_emails?
      }
    end

    def update_settings
      raise(NotFoundError) if current_user.nil?

      Public::Users::Settings::Update.call(current_user, settings_params)

      redirect_to '/users/settings', notice: { message: 'Settings updated', status: 'success' }
    end

    private

    def sign_up_params
      params.require(:user).permit(:email)
    end

    def settings_params
      params.permit(:allow_emails)
    end
  end
end
