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
        
        if user&.authenticate(params[:password])
          
          payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
          token = JWT.encode(payload, "123456789", 'HS256')
         
          { token: token, user: { id: user.id, email: user.email,role: user.role}}
        else
          error!('Invalid email or password', 401)
        end
      end

      desc "Logout a user"
      delete "/logout" do
        
        { message: 'Logged out successfully' }
      end

      desc "Get current user"
      get "/current_user" do
        authenticate!
       {
        user: Current.user,
        message: "User Logged Out Succcessfully"
       }
      end

    end
    
end