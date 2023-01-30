class Admin < ApplicationRecord
    attr_accessor :password

    validates :name, presence: true, length: { minimum: 2, maximum: 30 }
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email format" }
    validates :password, presence: true, length: { minimum: 8 }, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)\S{8,}\z/, message: "must contain at least one lowercase letter, one uppercase letter, and one digit" }

    has_secure_password
end
