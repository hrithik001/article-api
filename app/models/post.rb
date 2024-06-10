class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
  
    validates :post_title, presence: true
    validates :post_content, presence: true
    validate :can_user_create ,on: :create
    validate :can_user_edit ,on: :update
    validate :can_user_destory?

    private
    def can_user_create
        if Current.user.role == 'user'
            errors.add(:base, 'You are not authorized to create posts.')
          end
    end
    def can_user_edit
        if Current.user.role == 'user' && Current.user != user
            errors.add(:base, 'You are not authorized to edit posts.')
          end
    end 
    def can_user_destory?
        unless user == Current.user || Current.user.role == 'admin'
          errors.add(:base, 'You are not authorized to delete this post')
        end
    end
        
end
