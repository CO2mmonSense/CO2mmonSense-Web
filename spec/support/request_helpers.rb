module RequestHelpers
    def login_as(user = FactoryBot.create(:user))
        post user_session_path, params: { 
            user: { 
                email: user.email, 
                password: user.password 
            } 
        }
    end
end