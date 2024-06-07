class Api::V1::Users < Grape::API
    resources :users do

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
        end
        post "add_user" do
            User.create!(params)
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