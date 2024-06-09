class Api < Grape::API
    
    
    
    format :json

    mount Api::V1::Posts
    mount Api::V1::Users
    mount Api::V1::Sessions
    mount Api::V1::Comments
end
