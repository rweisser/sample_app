class User < ActiveRecord::Base
  # default_scope { order :id }  (caused problem when I wanted a
  #                               different sort order)

  before_save   { email.downcase! }
  before_create :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name,  presence:   true,
                    length:     { maximum: 50 }

  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  # has_secure_password validates password for presence, so it is
  # only necessary to validate length.
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # For testing:
  def to_s
    <<EOS
User
  id: #{id}
  name: #{name}
  email: #{email}
  created_at: #{created_at}
  updated_at: #{updated_at}
  password_digest: #{password_digest}
  remember_token: #{remember_token}
  admin: #{admin}
EOS
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
