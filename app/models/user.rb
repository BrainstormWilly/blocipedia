class User < ActiveRecord::Base
  has_many :wikis

  before_save { self.email = email.downcase }
  after_initialize { self.role ||= :member }

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:member, :premium, :admin]

end
