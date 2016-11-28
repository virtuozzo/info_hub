module Core
  module SpecHelpers
    module Permission
      def stub_permissions!(user, *identifiers)
        allow(user).to receive(:permission_identifiers).and_return identifiers

        user
      end

      def stub_vm_creation_permissions!(user)
        stub_permissions!(user,
                          'virtual_machines.select_instance_package_on_creation',
                          'virtual_machines.select_resources_manually_on_creation')
      end
    end
  end
end

RSpec.configure do |config|
  config.include Core::SpecHelpers::Permission, permission_helper: true
end
