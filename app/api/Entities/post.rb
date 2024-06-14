module Entities
    class Post < Grape::Entity
      expose :id
      expose :post_title
      expose :post_content
    end
  end