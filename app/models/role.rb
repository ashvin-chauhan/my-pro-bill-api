class Role < ApplicationRecord
  acts_as_paranoid
  has_many :roles_user, dependent: :destroy
  has_many :users, through: :roles_user
end
