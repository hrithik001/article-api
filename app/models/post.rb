class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
  
    validates :post_title, presence: true
    validates :post_content, presence: true
end
