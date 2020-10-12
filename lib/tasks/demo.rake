namespace :example do

  desc "Initialize SlaDock demo status"
  
  task demo_initial: :environment do
    puts "#{User.find(1).email}"
  end
end