module Entities
    class Report < Grape::Entity
      expose :id
      expose :reason
      expose :status
      expose :user, using: Entities::User
      expose :post, using: Entities::Post
    end
  end
  