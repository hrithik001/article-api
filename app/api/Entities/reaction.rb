module Entities
    class Reaction < Grape::Entity
      expose :id
      expose :reaction_type
      expose :user_id
   
    end
  end
  