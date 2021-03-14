class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one_attached :avatar

  extend FriendlyId
  friendly_id :username, use: :slugged
  
  has_many :articles, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :followed_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followeds, through: :followed_relationships, source: :followed

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validate :validate_username

  def to_param
    username
  end

  def follow!(user_id)
    followed_relationships.create(followed_id: user_id)
  end

  def unfollow!(user_id)
    followed_relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user_id)
    followed_relationships.find_by(followed_id: user_id)
  end

  def favorite(article)
    favorites.find_or_create_by(article: article)

    article.reload
  end

  def unfavorite(article)
    favorites.where(article: article).destroy_all

    article.reload
  end

  def favorited?(article)
    favorites.find_by(article_id: article.id).present?
  end
  
  # attr_writer :login
    
  # def login
  #   @login || username || email
  # end

  def validate_username
    errors.add(:username, :invalid) if User.where(email: username).exists?
  end

  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   if login = conditions.delete(:login)
  #     where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
  #   elsif conditions.key?(:username) || conditions.key?(:email)
  #     where(conditions.to_h).first
  #   end
  # end
end
