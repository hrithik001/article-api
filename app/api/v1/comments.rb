class Api::V1::Comments < Grape::API 
    helpers AuthHelpers
    
    resources :posts do
      route_param :post_id do
        resources :comments do
          before do
            authenticate!
          end
  
          desc "Get all comments of a post"
          get do
            post = Post.find(params[:post_id])
            comments = post.comments.where(parent_id: nil)
  
            if comments.empty?
              { post: post, message: 'No comments for this post' }
            else
              { post: post, comments: comments }
            end
          end
  
          desc "Create a comment for a post"
          params do
            requires :content, type: String
           
          end
          post do
            post = Post.find(params[:post_id])
            comment = post.comments.create!(
              content: params[:content],
              user: Current.user,
              
            )
            

          end
  
          desc "Delete a comment"
          params do
            requires :id, type: Integer
          end
          delete ':id' do
            comment = Comment.find(params[:id])

            if comment.user_can_delete?
              comment.destroy
              { message: "comment deleted successfully"}
            else
              error!('You are not authorized to delete this comment', 403)
            end
          end
  
          desc "Edit a comment"
          params do
            requires :id, type: Integer
            requires :content, type: String
          end
          patch ':id' do
            comment = Comment.find(params[:id])
            if comment.update(content: params[:content])
              { comment: comment }
            else
              error!(comment.errors.full_messages.to_json, 422)
            end
          end
  
          desc "Get replies for a comment"
          params do
            requires :id, type: Integer
          end
          get ':id/replies' do
            comment = Comment.find(params[:id])
            replies = comment.replies
  
            if replies.empty?
              { comment: comment, message: 'No replies for this comment' }
            else
              { comment: comment, replies: replies }
            end
          end

          desc "Create a reply to a comment"
          params do
            requires :id, type: Integer
            requires :content, type: String
          end

          post ':id/replies' do
            comment = Comment.find(params[:id])
            reply = comment.replies.create!(
              content: params[:content],
              user: Current.user,
              post_id: comment.post_id,
              parent_id: comment.id
            )

            { reply: reply }
          end

        end
      end
    end
  end
  