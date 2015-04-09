class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :goal

  has_many :post_topics
  has_many :topics, through: :post_topics

  validates :content, presence: true

  default_scope {order('posts.created_at DESC')}
  scope :from_users_followed_by, lambda { |user| followed_by(user)}

  private
    def self.followed_by(user)
      following_ids = %(SELECT target_id FROM connections
                        WHERE follower_id = :user_id)
      where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: user)
    end
end
