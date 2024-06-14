module Entities
    class PostInfo < Grape::Entity
      expose :id
      expose :post_title
      expose :post_content
      expose :user_id
      expose :reactions, using: Entities::Reaction
    end
  end
  