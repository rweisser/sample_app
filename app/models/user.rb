class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

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

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
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
