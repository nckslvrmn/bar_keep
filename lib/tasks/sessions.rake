namespace :sessions do
  desc "Clean up expired sessions"
  task cleanup: :environment do
    expired_count = Session.expired.destroy_all.count
    puts "Cleaned up #{expired_count} expired sessions"
  end
end
