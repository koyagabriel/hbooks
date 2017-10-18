class AuthenticateUser
  attr_reader :username, :password
  def initialize(username, password)
    @username = username
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  def user
    user = User.find_by(username: username)
    return user if user && user.authenticate(password)
    # raise authentication error if credentials are invalid
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
