
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
            optional :query, type: String, desc: "Search query"
            optional :tag, type: String, desc: "Tag to filter posts"
        end
        get do
          page = params[:page] || 1
          per_page = params[:per_page] || Kaminari.config.default_per_page
          query = params[:query]
          tag_name = params[:tag]
        
          posts = Post.search_posts(query: query, tag_name: tag_name).includes(:tags, :reactions).page(page).per(per_page)
        
          if posts.any?
           {
            posts: posts,

            pagination: {
              current_page: posts.current_page,
              total_pages: posts.total_pages,
              total_items: posts.total_count,
              per_page: posts.limit_value
            }
           }
          else
            { message: "No posts found" }
          end
        end
        
        #my posts 
        desc "get my posts"
        get 'myposts' do
          authenticate!
          user = Current.user
        
          if %w[admin author].include?(user.role)
            posts = Post.posts_by_user(user).includes(:tags, :reactions)
        
            if posts.any?
              present posts, with: Entities::Post, user: user
            else
              { message: "No posts found for the user" }
            end
          else
            error!({ error: 'You are not authorized to view this content' }, 403)
          end
        end

        # one post
        desc "get one post"

        params do
            requires :id ,type: Integer 
        end
        get ":id" do
          post = Post.find_by(id: params[:id])
          if post
            present post, with: Entities::Post
          else
            error!({ message: 'Post not found' }, 404)
          end
        end
        
        # delete the post

        desc "delete the post"
        params do
            requires :id , type: Integer
        end
        delete "post/:id" do 
            post = Post.find(params[:id])
            if post.can_user_destory? && post.destroy
                
                { message: 'posts destroyed successfully!!' }
            else
                error!(post.errors.full_messages.to_json, 403)
            end

            
        end

        # edit the post

        desc "edit the post"
        params do
            requires :id , type: Integer
            
            optional :post_title , type: String
            optional :post_content, type: String
        end
        patch ":id/edit" do 
          post = Post.find(params[:id])
          result = post.update_post(params)
          if result.is_a?(Post)
            present result, with: Entities::Post
          else
            error!(result, 403)
          end
        end


        # creating the new posts
        desc "Create a new posts"
        params do   
            
            requires :post_title, type: String 
            requires :post_content, type: String 
            requires :tag_names, type: Array[String]
        end
        post "create_post" do
          post = Post.create_with_tags(params, Current.user)

          if post.persisted?
            present :post, post, with: Entities::Post
          else
            error!(post.errors.full_messages.to_json, 422)
          end
        end


        # report a post

        desc "Report a post"
        params do
          
          requires :reason, type: String, desc: "Reason for reporting the post"
        end
        post ':post_id/report' do
          result = Report.report_post(params, Current.user)
          if result[:message]
            { message: result[:message], report: result[:report] }
          else
            error!(result[:error], 422)
          end
        end


        
    end
end