class CreateUser < ActuveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :password
      t.integer :failed_login_count
    end 
  end
end
