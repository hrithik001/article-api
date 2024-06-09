class User < ApplicationRecord
    VALID_ROLES = ['admin', 'author', 'user'].freeze

    validates :role, presence: true, inclusion: { in: VALID_ROLES }
    
    has_secure_password
    
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
end
