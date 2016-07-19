class Collaborator < ActiveRecord::Base
  belongs_to :wiki
  belongs_to :user

  def self.publicized_wiki(wiki)
    collabs = self.where(wiki: wiki)
    collabs.delete_all
  end

  def self.delete_user_wikis(user)
    collabs = self.where(wiki: Wiki.where(user: user))
    collabs.delete_all
  end

end
