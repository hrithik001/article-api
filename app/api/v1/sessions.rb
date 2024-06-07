class Api::V1::Sessions < Grape::API 

     helpers AuthHelpers
     resource :sessions do
      desc "Login a user"
      params do
        requires :email, type: String
        requires :password, type: String
      end
      post "/login" do
        user = User.find_by(email: params[:email])
        Current.user = user
        if user&.authenticate(params[:password])
          token = JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, "123456789", 'HS256')
          cookies[:user_session] = { value: token, httponly: true, secure: true }
          { message: 'Logged in successfully', user: user.as_json(only: [:id, :email, :name]) }
        else
          error!('Invalid email or password', 401)
        end
      end

      desc "Logout a user"
      delete "/logout" do
        cookies.delete(:user_session)
        { message: 'Logged out successfully' }
      end

      desc "Get current user"
      get "/current_user" do
        authenticate!
        present current_user, with: Entities::User
      end

    end
    
end