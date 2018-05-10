# frozen_string_literal: true

require 'sequel'
require 'json'

module Wefix
  # Models a registered account
  class Account < Sequel::Model
    one_to_many :owned_groups, class: :'Wefix::Group', key: :owner_id
    plugin :association_dependencies, owned_groups: :destroy

    many_to_many :collaborations,
                 class: :'Wefix::Group',
                 join_table: :accounts_groups,
                 left_key: :collaborator_id, right_key: :group_id

    plugin :whitelist_security
    set_allowed_columns :username, :email, :password

    plugin :timestamps, update_on_create: true

    def groups
      owned_groups + collaborations
    end

    def password=(new_password)
      self.salt = SecureDB.new_salt
      self.password_hash = SecureDB.hash_password(salt, new_password)
    end

    def password?(try_password)
      try_hashed = SecureDB.hash_password(salt, try_password)
      try_hashed == password_hash
    end

    def to_json(options = {})
      JSON(
        {
          type: 'account',
          id: id,
          username: username,
          email: email
        }, options
      )
    end
  end
end
