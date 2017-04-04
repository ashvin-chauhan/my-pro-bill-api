class Service < ApplicationRecord
  acts_as_paranoid
  belongs_to :client_type
end
