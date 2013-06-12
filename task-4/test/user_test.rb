require_relative 'test_helper'
require_relative '../lib/user'
require 'bcrypt'

describe User do
  include TestHelper
  subject(:user) {User.create(name: name, surname: surname, email: email, terms_of_use: terms_of_use, failed_login_count: failed_login, password: password, password_confirmation: password)}
  let(:name) {"ewelina"}
  let(:surname) {"mijal"}
  let(:email) {"ewelina@1000i.pl"}
  let(:terms_of_use) {"1"}
  let(:password) {"asdfasdfas"}
  let(:failed_login) {"0"}
  
    #it {should_not be_valid}
    it "should not accept empty name" do
      user.name = ""
      user.should_not be_valid
    end
    
    it "should not accept empty surname" do
      user.surname = ""
      user.should_not be_valid
    end
    
    it "should not accept name > 20" do
      user.name = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
      user.should_not be_valid
    end
    
    it "should not accept empty surname > 30" do
      user.should be_valid
      user.surname = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
      user.should_not be_valid
    end

    it "should not accept wrong email" do
      user.should be_valid
      user.email = "aa@aa"
      user.should_not be_valid
      user.email = "aa"
      user.should_not be_valid
      user.email = "@aa"
      user.should_not be_valid
      user.email = ""
      user.should be_valid
    end
    
    it "should not accept empty or short password" do
      user.should be_valid
      user.password = ""
      user.should_not be_valid
      user.password = "abcd"
      user.should_not be_valid
    end
    
    it "should not accept empty password confirmation" do
      user.should be_valid
      user.password_confirmation = ""
      user.should_not be_valid
    end
    
    it "should not accept empty terms of use" do
      user.should be_valid
      user.terms_of_use = "0"
      user.should_not be_valid
      user.terms_of_use = ""
      user.should_not be_valid
    end
    
    it "should not accept empty failed login count" do
      user.should be_valid
      user.failed_login_count = ""
      user.should_not be_valid
    end
    
    it "should return encrypted password" do
      user.password.should == password
    end
    
    it "should find by surname" do 
      user
      u = User.find_by_surname("mijal")
      u.surname.should == "mijal"
      u.email.should == "ewelina@1000i.pl"
    end
    
    it "should find user by email" do
        user
        u = User.find_by_email("ewelina@1000i.pl")
        u.surname.should == "mijal"
        u.email.should == "ewelina@1000i.pl"
      end

      it "should authenticate user using email and password" do
        user
        User.authenticate("ewelina@1000i.pl", "asdfasdfas").should == true
      end

      it "should have failed_login_count = 0" do
        user.failed_login_count.should == 0
      end

      it "should raise failed_login_count up to 2 and find suspicious user which was trying to hack this service" do
        user
        3.times do
          User.authenticate("ewelina@1000i.pl", "bleble")
        end
        User.find_by_email("ewelina@1000i.pl").failed_login_count.should == 3
        User.find_suspicious_users.count.should == 1
      end
end
