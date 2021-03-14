class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :body
  has_one_attached :main_image
  is_impressionable

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true, allow_blank: false
  validates :body, presence: true, allow_blank: false
  validates :slug, uniqueness: true, exclusion: { in: ['feed'] }
  
  #before_validation do
  #  self.slug ||= "#{title.to_s.parameterize}-#{rand(36**6).to_s(36)}"
  #end

  after_create :create_notification

  acts_as_taggable_on :tags
  scope :authored_by, -> (username) { where(user: User.where(username: username)) }
  scope :favorited_by, -> (username) { joins(:favorites).where(favorites: {user: User.where(username: username)} )}

  #def to_param
  #  slug
  #end

  def self.impressions
    impression.where(impressionable_type: "Article")
  end

  private

  def create_notification
    Notification.create!(
      title: "Article #{self.title} is created",
      user_id: 1
    )
  end
end
