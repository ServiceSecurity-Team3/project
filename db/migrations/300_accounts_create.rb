# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id

      String :username, null: false, unique: true
      String :email,f  null: false, unique: true
      String :password_hash
      String :salt
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
