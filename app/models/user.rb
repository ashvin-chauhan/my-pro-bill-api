class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable

  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  validates :subdomain, :company, :phone ,:presence => true, :uniqueness => true
  validates :first_name, :last_name,:presence => true
  validates :password, allow_nil: true, length: {in: Devise.password_length }, format: { with: PASSWORD_FORMAT, message: "Must in format of upper and lower case mix with at least 1 number and 1 special character." }
  # validates_confirmation_of :password

  has_many  :users_client_types ,dependent: :destroy
  has_many  :client_types , through: :users_client_types

  def password_required?
    if confirmed?
    	super
    else
    	false
    end
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
