module AuthHelpers
    def authenticate!
      token = cookies[:user_session]
      puts "token here --> #{token}"
      if token
        
          payload = JWT.decode(token, "123456789", true, { algorithm: 'HS256' }).first
          puts "payload data #{payload.inspect}"
          Current.user = User.find(payload["user_id"])
          if !Current.user
            error!('Unauthorized - Invalid token', 401)
          end
      else
        error!('Unauthorized - No token provided', 401)
      end
    end
  
    def current_user
      Current.user
    end
  end