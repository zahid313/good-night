class User < ApplicationRecord
    validates :name, presence: true
    has_many :sleep_records, dependent: :destroy
    has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
    has_many :passive_follows, class_name: 'Follow', foreign_key: 'following_id', dependent: :destroy
    has_many :followings, through: :active_follows, source: :following
    has_many :followers, through: :passive_follows, source: :follower
    has_many :friends, through: :followings  

    def friend_sleep_records(page: 1)
        following_ids = followings.pluck(:id)
        SleepRecord
        .where(user_id: following_ids)
        .where("start_time >= ?", 1.week.ago)
        .order(duration: :desc)
        .page(page)
    end    
end
