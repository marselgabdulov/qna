class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    callback_for('Github')
  end

  def vkontakte
    callback_for('Vkontakte')
  end

  private

  def callback_for(provider)
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif no_email?
      enter_email
    else
      redirect_to root_path, alert: t('oauth.unknown_error')
    end
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  def no_email?
    !auth[:info]&.dig(:email)
  end

  def set_oauth_session
    session[:oauth] = { provider: auth[:provider], uid: auth[:uid].to_s }
  end

  def enter_email
    set_oauth_session
    flash[:alert] = t('oauth.enter_email')
    render template: 'users/noemail_signup'
  end
end
