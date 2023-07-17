class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    @email = auth.info[:email]
    return unless @email

    user.create_authorization(auth)
    user
  end

  private

  def user
    @user ||= User.where(email: @email).first || create_user!
  end

  def create_user!
    password = Devise.friendly_token[0, 20]
    new_user = User.new(email: @email, password: password, password_confirmation: password)

    new_user.skip_confirmation!
    new_user.save!

    new_user
  end
end
