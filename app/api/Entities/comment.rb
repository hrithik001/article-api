module Entities
    class Comment < Grape::Entity
      expose :id
      expose :post_id
      expose :user_id
      expose :content
    
    end
  end
  