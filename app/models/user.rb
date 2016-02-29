class User < ActiveRecord::Base
  def self.find_or_create_by_auth(opts)
    user = User.find_or_create_by(email: opts["email"])
    user.name = opts["name"]
    user.permission_id = opts["permission_id"]
    user.save
  end
end
