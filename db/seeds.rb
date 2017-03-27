# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create default role
["Super Admin", "Comapny Admin", "Worker", "Customer"]
	.map { |role| Role.find_or_create_by(name: role) }

[
["super_admin@gmail.com", "SuperAdmin", "super_admin@gmail.com", "hello123"],
]
.map { |email, username, uid, password| 
	User.find_or_create_by!(email: email, username: username) do |user|
		user.password = password
		user.password_confirmation = password
	end
}