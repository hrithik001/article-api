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
            optional :parent_id, type: Integer
          end
          post do
            post = Post.find(params[:post_id])
            comment = post.comments.create!(
              content: params[:content],
              user: Current.user,
              parent_id: params[:parent_id]
            )
            { comment: comment }
          end
  
          desc "Delete a comment"
          params do
            requires :id, type: Integer
          end
          delete ':id' do
            comment = Comment.find(params[:id])
            error!('Forbidden', 403) unless comment.user == Current.user || Current.user.admin?
            comment.destroy
          end
  
          desc "Edit a comment"
          params do
            requires :id, type: Integer
            requires :content, type: String
          end
          patch ':id' do
            comment = Comment.find(params[:id])
            error!('Forbidden', 403) unless comment.user == Current.user 
            comment.update!(content: params[:content])
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
        end
      end
    end
  end
  