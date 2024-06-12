class Reaction < ApplicationRecord
  belongs_to :post
  belongs_to :user
  
  validates :reaction_type, presence: true, inclusion: { in: ['thumbsup', 'thumbsdown'], message: "must be 'thumbsup' or 'thumbsdown'" }
  
end
