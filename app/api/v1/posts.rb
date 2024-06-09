
require 'kaminari'

class Api::V1::Posts < Grape::API 

    helpers AuthHelpers
    

    resources :posts do
        before do
            authenticate!
        end
      
       
        desc "Get all posts with pagination"

        params do
            optional :page, type: Integer, default: 1, desc: "Page number"
            optional :per_page, type: Integer, default: 2, desc: "Posts per page"
        end
        get do
            page = params[:page] || 1
            per_page = params[:per_page] || Kaminari.config.default_per_page

            posts = Post.select(:id, :post_title, :post_content)
                        .page(page)
                        .per(per_page)

            { posts: posts, page: page, per_page: per_page, total_pages: posts.total_pages }
        end

        # one post
        desc "get one post"

        params do
            requires :id ,type: Integer 
        end
        get "post/:id" do
            Post.find_by(id: params[:id])
        end
        
        # delete the post

        desc "delete the post"
        params do
            requires :id , type: Integer
        end
        delete "post/:id" do 
            post = Post.find(params[:id])
          error!('Forbidden', 403) unless post.user == Current.user || Current.user.admin?
          post.destroy
        end

        # edit the post

        desc "edit the post"
        params do
            requires :id , type: Integer
            
            optional :post_title , type: String
            optional :post_content, type: String
        end
        patch "post/edit/:id" do 
            post = Post.find(params[:id])
            error!('Forbidden', 403) unless post.user == Current.user 
            post.update!(
              post_title: params[:post_title],
              post_content: params[:post_content]
            )
        end

        # creating the new posts
        desc "Create a new posts"
        params do   
            requires :user_id, type: Integer
            requires :post_title, type: String 
            requires :post_content, type: String 
        end
        post "create_post" do
            Post.create!(
                post_title: params[:post_title],
                post_content: params[:post_content],
                user: Current.user
              )
        end


    end
end