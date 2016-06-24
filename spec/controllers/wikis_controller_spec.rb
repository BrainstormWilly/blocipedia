require 'rails_helper'

RSpec.describe WikisController, type: :controller do

  let( :test_user ) { create(:user)}
  let( :public_wiki ) { create(:wiki, user: test_user) }

  context "guest user" do

    describe "GET index" do
      it "returns http redirect" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET show" do
      it "public wiki returns http redirect" do
        get :show, id: public_wiki.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST create" do
      it "returns http redirect" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET edit" do
      it "returns http redirect" do
        get :edit, id: public_wiki.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end # end guest user context


  context "member user doing CRUD on a public wiki they don't own" do

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user)
      @user.confirm
      sign_in @user
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET show" do
      it "returns http success" do
        get :show, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view" do
        get :show, id: public_wiki.id
        expect(response).to render_template :show
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST create" do
      it "increases the number Wikis by 1" do
        expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Wiki, :count).by(1)
      end
      it "assigns the new wiki to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki) ).to eq Wiki.last
      end
      it "redirects to the new Wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to Wiki.last
      end
      it "expects :private to be false" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki).private ).to be_falsey
      end
    end

    describe "GET edit" do
      it "returns http redirect" do
        get :edit, id: public_wiki.id
        expect(response).to redirect_to public_wiki
      end
    end

    describe "PUT update" do
      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: public_wiki.id, post: {title: new_title, body: new_body}
        expect(response).to redirect_to public_wiki
      end
    end

    describe "DELETE destroy" do
      it "returns http redirect" do
        delete :destroy, id: public_wiki.id
        expect(response).to redirect_to public_wiki
      end
    end

  end # member user doing CRUD on a public wiki they don't own


  context "member user doing CRUD on a public wiki they own" do

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      test_user.confirm
      sign_in test_user
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET show" do
      it "returns http success" do
        get :show, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view" do
        get :show, id: public_wiki.id
        expect(response).to render_template :show
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST create" do
      it "increases the number Wikis by 1" do
        expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Wiki, :count).by(1)
      end
      it "assigns the new wiki to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki) ).to eq Wiki.last
      end
      it "redirects to the new Wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to Wiki.last
      end
      it "expects :private to be false" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki).private ).to be_falsey
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, id: public_wiki.id
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, id: public_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq public_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to public_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, id: public_wiki.id
        count = Wiki.where({id: public_wiki.id}).size
        expect(count).to eq 0
      end

      it "redirects to wikis index" do
        delete :destroy, id: public_wiki.id
        expect(response).to redirect_to wikis_index_path
      end
    end

  end # member user doing CRUD on a public wiki they own


end
