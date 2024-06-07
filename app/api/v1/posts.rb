class Api::V1::Posts < Grape::API 

    helpers AuthHelpers
    

    resources :posts do
        before do
            authenticate!
        end
       
        desc "Get all posts"
        get do
            Post.all
        end
        desc "get one post"

        params do
            requires :id ,type: Integer 
        end
        get ":id" do
            Post.find_by(id: params[:id])
        end
        
        desc "delete the post"
        params do
            requires :id , type: Integer
        end
        delete ":id" do 
            Post.find_by(id: params[:id]).delete
        end

        desc "edit the post"
        params do
            requires :id , type: Integer
            
            optional :post_title , type: String
            optional :post_content, type: String
        end
        patch ":id" do 
            Post.find_by(id: params[:id]).update(params)
        end


        desc "Create a new posts"
        params do   
            requires :post_title, type: String 
            requires :post_content, type: String 
        end
        post do
            Post.create!(
                params
            )
        end


    end
end