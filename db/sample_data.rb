# encoding: utf-8

puts "Creating users..."
user1 = User.find_by_email("user@gmail.com")
unless user1
  user1 = User.new(:email => "user@gmail.com", :password => "123456", :first_name => 'Michael', :last_name => 'Jordan')
  user1.admin = true
  user1.save!
end
user1.profile.update_attributes(
  company: "yafoy",
  localization: "fr-CA",
  hours_per_day: 7.5,
  tax1_label: "TPS",
  tax1: 5,
  tax2_label: "TVQ",
  tax2: 9.5,
  compound: true,
  fiscal_year: "0001-03-01",
  invoice_signature:
"Merci pour votre confiance.

Cordialement,

Olivier"
)
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

puts "Creating categories..."
Category.create([{name: 'Auto', user_id: 1}, {name: 'Food', user_id: 1}, {name: 'Internet', user_id: 1}, {name: 'Consulting', user_id: 2}])

puts "Creating transactions..."
500.times do |t|
  user = User.all.sample
  transaction = user.transactions.create(
    :expense => [true, false].sample,
    :date => Date.today - (1..900).to_a.sample,
    :note => "Transaction #{t}",
    :total => [ 10, 20, 30, 3.5, 43.5, 110, 7.5, 12.5, 50, 450, 999, 1200, 1000.5 ].sample,
    :tax1 => [ 0, 1, 2, 3, 3.5, 43.5, 11, 7.5, 12.5, 50, 450, 1200 ].sample,
    :tax2 => [ 0, 1, 2, 3, 3.5, 43.5, 11, 7.5, 12.5, 50, 450, 1200 ].sample,
    :category_id => user.categories.map(&:id).sample
  )
  transaction.save
end

puts "All set"