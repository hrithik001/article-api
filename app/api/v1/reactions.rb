class Api::V1::Reactions < Grape::API
    helpers AuthHelpers

    resources :posts do
        route_param :post_id do
            resources :reactions do
                before do
                    authenticate!
                end

                desc "Get reactions for a post"
                get do
                    post = Post.find(params[:post_id])
                    reaction = post.reactions.select(:reaction_type).map(&:reaction_type)
                    
                    if reaction.present?
                        
                        
                            present :post, post, with: Entities::PostInfo
                            
                            
                        
                    else
                        {
                            post: post,
                            message: "No reactions for the posts"
                        }
                    end
                end

                desc "Create or update a reaction on a post"
                params do
                    requires :reaction_type, type: String, values: ['thumbsup', 'thumbsdown'], desc: "Reaction type"
                end
                post do
                    post = Post.find(params[:post_id])
                    user = Current.user
                    reaction = post.reactions.find_or_initialize_by(user: user)

                    if reaction.persisted?
                        
                            reaction.update!(reaction_type: params[:reaction_type])
                            present :reaction, reaction, with: Entities::Reaction
                       
                    else
                        reaction.reaction_type = params[:reaction_type]
                        reaction.save!
                        present :reaction, reaction, with: Entities::Reaction
                    end
                end

                desc "Delete a reaction from a post"
                delete ':id' do
                    post = Post.find(params[:post_id])
                    reaction = post.reactions.find(params[:id])
                    if reaction.user == Current.user
                        reaction.destroy
                        { message: "Reaction deleted" }
                    else
                        error!({ message: "You are not authorized to delete this reaction" }, 403)
                    end
                end
            end
        end
    end
end
