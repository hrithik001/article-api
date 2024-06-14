module Entities
  class Post < Grape::Entity
    expose :id
    expose :post_title
    expose :post_content
    expose :user_id
    expose :tags, using: Entities::Tag
    expose :reactions, using: Entities::Reaction
    expose :comments, using: Entities::Comment
  end
end
