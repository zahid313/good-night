class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  def approve
    self.update(approved: true)
  end

  def reject
    self.destroy
  end  
end
