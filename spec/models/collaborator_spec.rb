require 'rails_helper'

RSpec.describe Collaborator, type: :model do

  let( :wiki_creator ){ create(:user) }
  let( :wiki_user ){ create(:user)}
  let( :wiki ){ create(:wiki, private: true, user: wiki_creator) }
  let( :collaborator ){ create(:collaborator, wiki: wiki, user: wiki_user) }

  describe "attributes" do
    it "has wiki and user" do
      expect(collaborator).to have_attributes(wiki: wiki, user: wiki_user)
    end
  end

end
