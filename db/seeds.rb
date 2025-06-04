# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create default user if none exist
if User.count.zero?
  default_user = User.create!(
    username: 'admin',
    password: 'changeme123',
    password_confirmation: 'changeme123'
  )

  puts "Default user created:"
  puts "Username: admin"
  puts "Password: changeme123"
  puts "Please change the password after first login!"
end
