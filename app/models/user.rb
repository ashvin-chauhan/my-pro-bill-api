class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable

  # Validations
  validates :subdomain, :company, :phone ,:presence => true, :uniqueness => true
  validates :first_name, :last_name,:presence => true

  # Associations
  has_many  :users_client_types ,dependent: :destroy
  has_many  :client_types , through: :users_client_types
  has_many :roles_user, dependent: :destroy
  has_many :roles, through: :roles_user

  # Scopes
  scope :super_admin, -> { joins(:roles).where(roles: {name: "Super Admin"}) }
  scope :clients, -> { joins(:roles).where(roles: {name: "Client Admin"}) }
  scope :workers, -> { joins(:roles).where(roles: {name: "Worker"}) }
  scope :customers, -> { joins(:roles).where(roles: {name: "Customer"}) }

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

end
