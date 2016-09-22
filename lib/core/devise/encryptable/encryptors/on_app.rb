module Devise
  module Encryptable
    module Encryptors
      class OnApp < ::Devise::Encryptable::Encryptors::Base
        def self.salt(stretches)
          SecureRandom.hex(20)
        end

        def self.digest(password, stretches, salt, pepper)
          secure_digest(salt, password, ::OnApp.configuration.authentication_key)
        end

        def self.secure_digest(*args)
          Digest::SHA1.hexdigest(args.flatten.join('--'))
        end
      end
    end
  end
end
