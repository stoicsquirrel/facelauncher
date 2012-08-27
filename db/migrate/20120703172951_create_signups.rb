class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :status
      t.string :zip
      t.string :ip_address

      t.timestamps
    end
  end
end
