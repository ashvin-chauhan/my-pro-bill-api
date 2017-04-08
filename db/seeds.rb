# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create default role
["Super Admin", "Client Admin", "Worker", "Sub Admin", "Customer"]
  .map { |role| Role.find_or_create_by(name: role) }

[
["super_admin@gmail.com", "SuperAdmin", "hello123", "SuperAdmin", 'SuperAdmin', '9999999999', 'SuperAdmin', 'SuperAdmin'],
]
.map { |email, username, password, subdomain, company, phone, first_name, last_name|
  User.find_or_create_by!(email: email, username: username, subdomain: subdomain, company: company, phone: phone, first_name: first_name, last_name: last_name) do |user|
    user.roles << Role.where(name: 'Super Admin')
    user.password = password
    user.password_confirmation = password
  end
}