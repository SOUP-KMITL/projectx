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

    def user_from_api_key(key)
      settings.users.find { |user| user['api_key'] == key }
    end
  end
end

