class User < ActiveRecord::Base

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true
  # validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  # validates :password, length: { minimum: 6 }, allow_blank: true
  # validates :email,
  #             presence: true,
  #             uniqueness: { case_sensitive: false },
  #             length: { minimum: 3, maximum: 254 }
  #
  # has_secure_password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
end
