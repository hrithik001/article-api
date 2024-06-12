class Tag < ApplicationRecord
    has_many :posts_tags, dependent: :destroy
    has_many :posts, through: :posts_tags

    validates :name, presence: true, uniqueness: true
end
