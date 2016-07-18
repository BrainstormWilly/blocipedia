class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: {minimum: 20 }, presence: true
  validates :user, presence: true

  def self.publicize_user_wikis(user)
    # self.where(user: user).each do |w|
    #   w.private = false
    #   w.save
    # end
    self.where(user: user).update_all(private: false)
  end

end
