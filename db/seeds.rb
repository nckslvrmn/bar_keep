# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ANSI color codes
bold = "\e[1m"
green = "\e[32m"
yellow = "\e[33m"
red = "\e[31m"
reset = "\e[0m"

# Create default user if none exist
if User.count.zero?
  User.create!(
    username: 'admin',
    password: 'changeme123',
    password_confirmation: 'changeme123'
  )

  puts "\n#{bold}#{green}✓ Default user created:#{reset}"
  puts "#{bold}Username: #{yellow}admin#{reset}"
  puts "#{bold}Password: #{red}changeme123#{reset}"
  puts "\n#{bold}⚠️  Please change the password after first login!#{reset}\n\n"
end
