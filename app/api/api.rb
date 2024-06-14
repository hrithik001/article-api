class Api < Grape::API
    
    
    
    format :json

    mount Api::V1::Posts
    mount Api::V1::Users
    mount Api::V1::Sessions
    mount Api::V1::Comments
    mount Api::V1::Reactions
    mount Api::V1::Reports
end
