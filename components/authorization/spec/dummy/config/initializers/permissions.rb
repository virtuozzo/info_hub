Permissions::Factory.tap do |f|
  f.define :user do
    actions :create, :read, :update, :delete
  end
end