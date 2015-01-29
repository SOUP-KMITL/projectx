module XM
  module UserHelper
    def authenticate(username, password)
      settings.users.each do |user|
        if username == user['username'] &&
           password == user['password']
          return user['api_key']
        end
      end

      nil
    end
  end
end

