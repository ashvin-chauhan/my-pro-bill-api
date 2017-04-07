class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessor :role_names

  # Validations
  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  validates :subdomain, :company ,:presence => true, :uniqueness => true, if: :check_role?
  validates :phone, :presence => true, :uniqueness => true
  validates :first_name, :last_name, :presence => true
  validates :password, allow_nil: true, length: {in: Devise.password_length }, format: { with: PASSWORD_FORMAT, message: "Must in format of upper and lower case mix with at least 1 number and 1 special character." }

  # Associations
  has_many  :users_client_types ,dependent: :destroy
  has_many  :client_types , through: :users_client_types
  has_many  :services, through: :client_types
  has_many  :client_services, dependent: :destroy
  has_many  :roles_user, dependent: :destroy
  has_many  :roles, through: :roles_user
  has_many  :oauth_access_tokens, dependent: :destroy, foreign_key: :resource_owner_id
  has_one   :customer, dependent: :destroy
  has_many  :expense_categories, dependent: :destroy,foreign_key: :client_id

  # Get list of clients of specific customer
  has_many  :customers_clients, :class_name => "ClientsCustomer", :foreign_key => "customer_id", dependent: :destroy
  has_many  :clients, through: :customers_clients

  # Get list of customers of specific client
  has_many  :clients_customers, :class_name => "ClientsCustomer", :foreign_key => "client_id", dependent: :destroy
  has_many  :customers, through: :clients_customers

  has_many  :customers_service_prices, :foreign_key => "customer_id", dependent: :destroy
  accepts_nested_attributes_for :customer, :customers_service_prices, allow_destroy: true

  # Scopes
  scope :super_admin, -> { joins(:roles).where(roles: {name: "Super Admin"}) }
  scope :clients, -> { joins(:roles).where(roles: {name: "Client Admin"}) }
  scope :workers, -> { joins(:roles).where(roles: {name: "Worker"}) }
  scope :customers, -> { joins(:roles).where(roles: {name: "Customer"}) }

  # Instance method
  def super_admin?
    roles.find_by(name: 'Super Admin') ? true : false
  end

  def client?
    roles.find_by(name: 'Client Admin') ? true : false
  end

  def worker?
    roles.find_by(name: 'Worker') ? true : false
  end

  def customer?
    roles.find_by(name: 'Customer') ? true : false
  end

  def check_role?
    (role_names & ['Client Admin', 'Worker']).present? ? true : false
  end

  def password_required?
    if confirmed?
      super
    else
      false
    end
  end

  def role_names=(role)
    roles = Role.where("name IN (?)", role)
    self.roles << roles
    @role_names = role
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def active_user
    self.update_attributes(active:true)
  end

  before_commit do
    if self.customer? && !self.confirmed?
      password = Devise.friendly_token.first(8)
      skip_confirmation!
    end
  end

end
