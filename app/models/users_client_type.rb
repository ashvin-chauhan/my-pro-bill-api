class UsersClientType < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :client_type
end
