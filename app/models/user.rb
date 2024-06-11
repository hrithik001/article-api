class User < ApplicationRecord
    VALID_ROLES = ['admin', 'author', 'user'].freeze

    validates :role, presence: true, inclusion: { in: VALID_ROLES }
    validates :email, presence: true, uniqueness: true
    before_save :ensure_admin_privilege
    has_secure_password
    
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy

    private

    def ensure_admin_privilege
        if self.role == 'admin' && Current.user&.role != 'admin'
            errors.add(:role, 'Only an admin can assign admin role')
            throw(:abort)
        end
    end
end
