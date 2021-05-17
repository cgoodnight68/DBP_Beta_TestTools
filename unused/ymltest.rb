require 'yaml'
require 'pry'
users=YAML.load_file("bin/yml/users.yml")
environment ="qa-symphony"
username = users[environment]['user']
userpassword=users[environment]['password']

binding.pry



