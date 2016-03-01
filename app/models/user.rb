class User < ActiveRecord::Base
  has_many :journal_entries

  def self.find_or_create_by_auth(opts)
    user = User.find_or_create_by(email: opts["email"])
    user.name = opts["name"] if opts["name"]
    user.permission_id = opts["permission_id"] if opts["permission_id"]
    user.save
    user
  end
end
