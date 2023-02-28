class User < ApplicationRecord
    validates :name, presence: true
    has_many :sleep_records, dependent: :destroy
    has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
    has_many :passive_follows, class_name: 'Follow', foreign_key: 'following_id', dependent: :destroy
    has_many :following, through: :active_follows, source: :following
    has_many :followers, through: :passive_follows, source: :follower
      
end
