desc "Create a first user for single tenant mode"
task :create_user => :environment do
  user = build_user
  if user.valid?
    user.save
    puts "The user is created"
  else
    puts "This user is not valid"
  end
end

def build_user
  print "First name: "
  first_name = STDIN.gets.chomp
  print "Last name: "
  last_name = STDIN.gets.chomp
  print "email: "
  email = STDIN.gets.chomp
  print "Password: "
  password = STDIN.noecho(&:gets).chomp
  puts
  User.new(first_name: first_name,
           last_name: last_name,
           email: email,
           password: password,
           admin: true)
end
