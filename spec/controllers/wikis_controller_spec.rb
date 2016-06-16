require 'rails_helper'

RSpec.describe WikisController, type: :controller do

  let( :my_user ) { create(:user) }
  let( :my_public_wiki ) { create(:wiki, user: my_user) }

  context "guest user" do
    describe "GET index" do
      it "returns http redirect" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # context "member user" do
  #   before do
  #     user = User.create( name: "Mr. Blocipedia", email: "mr@blocipedia.com", password: "helloworld" )
  #     create_session( user )
  #   end
  #
  #   describe "GET index" do
  #     it "returns http success" do
  #       get :index
  #       expect(response).to have_http_status(:success)
  #     end
  #   end
  #
  #   describe "GET #show" do
  #     it "returns http success" do
  #       get :show, id: my_public_wiki.id
  #       expect(response).to have_http_status(:success)
  #     end
  #   end
  #
  #   describe "GET #new" do
  #     it "returns http success" do
  #       get :new, id: my_public_wiki.id
  #       expect(response).to have_http_status(:success)
  #     end
  #   end
  #
  #   describe "POST create" do
  #     it "increases the number Wikis by 1" do
  #       expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user}}.to change(Wiki, :count).by(1)
  #     end
  #     it "assigns the new wiki to @wiki" do
  #       post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user}
  #       expect( assigns(:wiki) ).to eq Wiki.last
  #     end
  #     it "redirects to the new Wiki" do
  #       post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user}
  #       expect(response).to redirect_to [my_public_wiki, Wiki.last]
  #     end
  #   end
  #
  #   describe "GET edit" do
  #     it "returns http success" do
  #       get :edit, id: my_public_wiki.id
  #       expect(response).to have_http_status(:success)
  #     end
  #
  #     it "renders the #edit view" do
  #       get :edit, id: my_public_wiki.id
  #       expect(response).to render_template :edit
  #     end
  #
  #     it "assigns wiki to be updated to @wiki" do
  #       get :edit, id: my_public_wiki.id
  #       wiki_instance = assigns(:wiki)
  #
  #       expect(wiki_instance.id).to eq my_public_wiki.id
  #       expect(wiki_instance.title).to eq my_public_wiki.title
  #       expect(wiki_instance.body).to eq my_public_wiki.body
  #     end
  #   end
  #
  #   describe "PUT update" do
  #     it "updates wiki with expected attributes" do
  #       new_title = RandomData.random_sentence
  #       new_body = RandomData.random_paragraph
  #
  #       put :update, id: my_public_wiki.id, post: {title: new_title, body: new_body}
  #
  #       updated_wiki = assigns(:post)
  #       expect(updated_wiki.id).to eq my_public_wiki.id
  #       expect(updated_wiki.title).to eq new_title
  #       expect(updated_wiki.body).to eq new_body
  #     end
  #
  #     it "redirects to the updated wiki" do
  #       new_title = RandomData.random_sentence
  #       new_body = RandomData.random_paragraph
  #
  #       put :update, id: my_public_wiki.id, post: {title: new_title, body: new_body}
  #       expect(response).to redirect_to [my_public_wiki]
  #     end
  #   end
  #
  #   describe "DELETE destroy" do
  #     it "deletes the wiki" do
  #       delete :destroy, id: my_public_wiki.id
  #       count = Wiki.where({id: my_public_wiki.id}).size
  #       expect(count).to eq 0
  #     end
  #
  #     it "redirects to wikis index" do
  #       delete :destroy, id: my_public_wiki.id
  #       expect(response).to redirect_to wikis_index_path
  #     end
  #   end
  # end


end
