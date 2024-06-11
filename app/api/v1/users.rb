class Api::V1::Users < Grape::API
    resources :users do
        helpers AuthHelpers

        before do
          authenticate!
        end

        # get all user
        desc "get all Users"
        get do
            User.all
        end

        # create a user
        desc "create a user"
        params do
            requires :email ,type: String
            requires :password ,type: String
            requires :password_confirmation, type: String
            requires :role, type: String
        end
        post "add_user" do
            
            user = User.new( 
                email: params[:email],
                password: params[:password],
                password_confirmation: params[:password_confirmation],
                role: params[:role] 
                )
            if user.save
                user
            else
                error!(user.errors.full_messages.to_json, 422)
            end
            rescue ActiveRecord::RecordInvalid => e
                error!(e.message, 422)
        
        end
        
        # edit a user
        desc "edit a user"
        params do
            requires :id, type: Integer
        end
        patch "edit/:id" do
            User.find_by(id:params[:id]).update(params)
            User.find_by(id:params[id])
        end

        # delete a user
        desc "delete a user"
        params do
            requires :id, type: Integer
        end
        delete do
            User.find_by(id: params[:id]).delete
        end

        # get a single user details
        desc "get a single user"
        params do
            requires :id, type: Integer
        end
        get ":id" do
            User.find_by(id:params[:id])
        end


        

    end
end