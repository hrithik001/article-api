
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
            query = params[:query] ? "%#{params[:query]}%" : nil
            tag_name = params[:tag]


            # if query.present?
            #     posts = Post.where('post_title  LIKE ? OR post_content LIKE ?',query, query )
            # end

            # if tag_name.present?
            #     posts = Tag.where('name  LIKE ? OR id LIKE ?',tag_name, tag_name.to_i )
            #     present posts
            # end

            

            posts = if tag_name.present?
                        tags = Tag.find_by(name: tag_name)
                        puts "tags form here #{tags}"
                        tags.posts
                    elsif params[:query].present?
                        Post.where('post_title LIKE ? OR post_content LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%")
                    else
                        Post.all
                    end.page(page).per(per_page)
            if posts.any?
            {
                post: posts.includes(:tags).map do |post|
                    {
                      id: post.id,
                      post_title: post.post_title,
                      post_content: post.post_content,
                      tags: post.tags.map(&:name), 
                      user_id: post.user_id,
                      created_at: post.created_at,
                      updated_at: post.updated_at
                    }
                  end,
                page: page,
                per_page: per_page,
                total_pages: posts.total_pages
            }
            else
            { message: "No posts found" }
            end
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
        patch "post/edit/:id" do 
            post = Post.find(params[:id])
            if post.can_user_edit && post.update(post_title: params[:post_title], post_content: params[:post_content])
                { post: post }
            else
                error!(post.errors.full_messages.to_json, 403)
            end
        end

        # creating the new posts
        desc "Create a new posts"
        params do   
            # requires :user_id, type: Integer
            requires :post_title, type: String 
            requires :post_content, type: String 
            requires :tag_names, type: Array[String]
        end
        post "create_post" do
            post = Post.new(
                post_title: params[:post_title],
                post_content: params[:post_content],
                user: Current.user
              )
              if post.save
                params[:tag_names].each do |tag_name|
                    tag = Tag.find_or_create_by(name: tag_name) 
                    post.tags << tag
                end
                { post: post }
              else
                error!(post.errors.full_messages.to_json, 422)
                
              end
        end


    end
end