# encoding: utf-8

puts "Creating default Emailing API"
Emailing.create(:description => '[TEST] Mailchimp - Clients list', :api_key => '7ee733e3c16671ed80d116acf8b1942a-us2', :list_key => 'ef5a8f01a9' )

puts "Creating users..."
user1 = User.find_by_email("user@gmail.com") || User.create!(:email => "user@gmail.com", :password => "123456", :first_name => 'Michael', :last_name => 'Jordan', :admin => 'true')
user2 = User.find_by_email("user2@gmail.com") || User.create!(:email => "user2@gmail.com", :password => "123456", :first_name => 'Magic', :last_name => 'Johnson')

puts "Creating customers..."
user1.customers.create(:user_id => '1', :name => 'CIC', :phone => '613 800 0845', :address1 => '333 Carling Ave.', :address2 => 'Suite A2', :city => 'Ottawa', :postal_code => 'K1N5T2', :province => 'Ontario', :country => 'Canada', :note => 'GitHub is more than just a place to share code.')

user1.customers.create(:user_id => '1', :name => 'AAFC', :phone => '613 800 0845', :address1 => '24 King street', :city => 'Ottawa', :postal_code => 'K1N5T2', :province => 'Ontario', :country => 'Canada')

user2.customers.create(:user_id => '2', :name => 'AGAP du Vieux Gatineau', :phone => '819 800 0845', :address1 => '24 King street', :city => 'Gatineau', :postal_code => 'J8X4P8', :province => 'Quebec', :country => 'Canada')

puts "Creating contacts..."
Contact.create(:customer_id => '1', :first_name => 'Nancy', :last_name => 'Camacho', :title => 'Project Manager', :phone => '613 400 0845', :email => 'Nancy@dev.koopon.ca')

Contact.create(:customer_id => '1', :first_name => 'Bonny', :last_name => 'Wong-Fortin', :title => 'Director', :phone => '613-952-5759', :email => 'Bonny@dev.koopon.ca')

Contact.create(:customer_id => '2', :first_name => 'Ron', :last_name => 'Lewis', :title => 'GIS Business OPS Team Lead', :phone => '415 400 0845', :email => 'Ron@dev.koopon.ca')

Contact.create(:customer_id => '3', :first_name => 'Pauline', :last_name => 'Delaire', :title => 'Directrice', :phone => '819 400 0845', :email => 'pauline@dev.koopon.ca')

puts "Creating projects..."
150.times do |p|
  user = User.all.sample
  project = user.projects.create(
    :title => "Project #{p}",
    :customer_id => user.customers.map(&:id).sample,
    :status => [ true, false ].sample,
    :default_rate => [ 10, 20, 30, 40, 50 ].sample,
    :billing_code_id => BillingCode.all.map(&:id).sample,
    :internal => [ true, false ].sample,
    :default_rate => [11, 11.5, 50, 35, 25.5].sample
  )
  project.save
end

puts "Creating activities..."
1000.times do |a|
  activity = Project.all.sample.activities.create(
    :description => "Activity numéro #{a}",
    :time => [ 1, 2, 3, 3.5, 4.5, 10, 7.5, 1.5, 8 ].sample,
    :date => Time.now.to_date
  )
  activity.save
end

puts "All set"