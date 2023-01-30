class User < ApplicationRecord
    # attr_accessor :password
    has_secure_password

    validates :name, presence: true, length: { minimum: 2, maximum: 30 }, format: { with: /\A[a-zA-Z]+\z/, message: "can only contain letters" }
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email format" }
    validates :password, presence: true, length: { minimum: 8 }

    
end
