class Auth < Motion::Authentication
  strategy DeviseTokenAuth
  sign_in_url "http://localhost:3000/api/v1/users/sign_in"
end
