module Devise
  module Strategies
    class ApiAuthenticatable < ::Devise::Strategies::Authenticatable
      def authenticate!
        auth_param = authentication_hash.values.first
        # search for an object with given login or email
        result = mapping.to.find_by_email(auth_param)? {:object => mapping.to.find_by_email(auth_param), :parameter => 'email'} :
                                                       {:object => mapping.to.find_by_login(auth_param), :parameter => 'login'}
        resource = valid_password? && result[:object]
        if resource && validate(resource) { resource.api_key? && resource.api_key == password && result[:parameter] == 'email'} # authenticate with email : API key
          resource.authenticated_with_key = true # 4447
          success!(resource)
        elsif resource.try(:regular_login_allowed?) && resource.valid_password?(password) # 284, 5046: authenticate with email/login : password
          success!(resource)
        elsif !halted?
          fail(:invalid)
        end
      end
    end
  end
end

Warden::Strategies.add(:api_authenticatable, Devise::Strategies::ApiAuthenticatable)
