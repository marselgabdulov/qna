class UsersController < ApplicationController
  def noemail_signup
    redirect_to root_path, alert: 'Wrong auth params' and return unless oauth_is_set?

    password = Devise.friendly_token[0, 20]
    @user = User.new(email: user_params[:email], password: password, password_confirmation: password)

    if @user.save
      @user.create_authorization(oauth)

      # after saving a new user, devise sends a confirmation email
      redirect_to root_path,
                  notice: 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account. After confirmation, sign in again.'
    else
      render :noemail_signup
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def oauth_is_set?
    !!session[:oauth]&.dig('provider') && !!session[:oauth]&.dig('uid')
  end

  def oauth
    Struct.new(:provider, :uid).new(session[:oauth]['provider'], session[:oauth]['uid'])
  end
end
