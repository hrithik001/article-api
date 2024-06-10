class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

  validate :user_can_edit, on: :update 
  validates :content, presence: true

  def user_can_delete?
    user == Current.user || Current.user.role == 'admin'
  end

  def user_can_edit
    unless user == Current.user
      errors.add(:base, 'You are not authorized to perform this action.')
    end
  end
end
