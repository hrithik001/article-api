class Api::V1::Comments < Grape::API 
    helpers AuthHelpers
    resources :posts do
        route_param :post_id do
            resources :comments do
                before do
                    authenticate!
                end

                desc "Get all comment of posts"
                get do
                    post = Post.find(params[:post_id])
                    comments = post.comments
                  
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
                    post.comments.create!(
                        content: params[:content],
                        user: Current.user
                    )
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
                    error!('Forbidden', 403) unless comment.user == current_user || current_user.admin?
                    comment.update!(content: params[:content])
                end
            end

        end
    end
end