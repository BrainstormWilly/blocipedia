class User < ActiveRecord::Base
  has_many :wikis
  has_many :collaborators, dependent: :destroy
  #has_many :collab_wikis, through: :collaborators, foreign_key: :user_id

  before_save { self.email = email.downcase }
  after_initialize { self.role ||= :member }

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:member, :premium, :admin]

end
