class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_provider, except: :sign_up

  def sign_up
    email = auth.info[:email]
    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      flash[:notice] = 'You have to confirm your email address before continuing.'
    end

    user.create_authorization(auth)
    redirect_to questions_path
  end

  def facebook
  end

  def twitter
  end

  private

  def sign_in_provider
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice,
                        :success,
                        kind: auth.provider.capitalize) if is_navigational_format?
    else
      flash[:notice] = 'Email is required to compete sign up'
      render 'omniauth_callbacks/request_email', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end
end
