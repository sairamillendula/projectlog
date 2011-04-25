user = User.create!(:email => "user@gmail.com", :password => "123456", :first_name => 'Michael', :last_name => 'Jordan')
user = User.create!(:email => "user2@gmail.com", :password => "123456", :first_name => 'Michael', :last_name => 'Jordan')

Customer.create(:user_id => '1', :name => 'CIC', :phone => '613 800 0845', :address1 => '333 Carling Ave.', :address2 => 'Suite A2', :city => 'Ottawa', :postal_code => 'K1N5T2', :province => 'Ontario', :country => 'Canada', :note => 'GitHub is more than just a place to share code.')

Customer.create(:user_id => '1', :name => 'AAFC', :phone => '613 800 0845', :address1 => '24 King street', :city => 'Ottawa', :postal_code => 'K1N5T2', :province => 'Ontario', :country => 'Canada')

Customer.create(:user_id => '2', :name => 'AGAP du Vieux Gatineau', :phone => '819 800 0845', :address1 => '24 King street', :city => 'Gatineau', :postal_code => 'J8X4P8', :province => 'Quebec', :country => 'Canada')

Contact.create(:customer_id => '1', :first_name => 'Nancy', :last_name => 'Camacho', :title => 'Project Manager', :phone => '613 400 0845', :email => 'nancy.camacho@cic.gc.ca')

Contact.create(:customer_id => '1', :first_name => 'Bonny', :last_name => 'Wong-Fortin', :title => 'Director', :phone => '613-952-5759', :email => 'Bonny@cic.gc.ca')

Contact.create(:customer_id => '2', :first_name => 'Ron', :last_name => 'Lewis', :title => 'GIS Business OPS Team Lead', :phone => '415 400 0845', :email => 'Ron.Lewis@aafc-aagc.gc.ca')

Contact.create(:customer_id => '3', :first_name => 'Pauline', :last_name => 'Delaire', :title => 'Directrice', :phone => '819 400 0845', :email => 'pauline@agapvieuxgatineau.ca')