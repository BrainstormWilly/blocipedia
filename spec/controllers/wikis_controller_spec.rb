 require 'rails_helper'
 include RandomData

RSpec.describe WikisController, type: :controller do

  let( :public_wiki ) { create(:wiki) }
  let( :private_wiki ) { create(:wiki, private: true) }

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
      it "private wiki returns http redirect" do
        get :show, id: private_wiki.id
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
      it "returns http redirect on public wiki" do
        get :edit, id: public_wiki.id
        expect(response).to redirect_to(new_user_session_path)
      end
      it "returns http redirect on private wiki" do
        get :edit, id: private_wiki.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end # end guest user context


  context "member user doing CRUD on a wiki they don't own" do

    before do
      @user = build(:user)
      @user.skip_confirmation!
      @user.save
      sign_in @user
      @other_user = build(:user)
      @other_user.skip_confirmation!
      @other_user.save
      public_wiki.user = @other_user
      public_wiki.save
      private_wiki.user = @other_user
      private_wiki.save
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET show" do
      it "public wiki returns http success" do
        get :show, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "public wiki renders the #show view" do
        get :show, id: public_wiki.id
        expect(response).to render_template :show
      end
      it "public wiki assigns wiki to be shown to @public_wiki" do
        get :show, id: public_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
      it "private wiki returns redirect to index" do
        get :show, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "renders the #new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe "POST create" do
      it "public wiki increases the number Wikis by 1" do
        expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Wiki, :count).by(1)
      end
      it "public wiki assigns the new wiki to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki) ).to eq Wiki.last
      end
      it "public wiki redirects to the new Wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to Wiki.last
      end
      it "public wiki expects :private to be false" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki).private ).to be_falsey
      end
      it "private wiki redirects to index" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}
        expect( response ).to redirect_to authenticated_root_path
      end
    end

    describe "GET edit" do
      it "public wiki returns http success" do
        get :edit, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "public wiki renders the #edit template" do
        get :edit, id: public_wiki.id
        expect(response).to render_template :edit
      end
      it "assigns public wiki to be updated to @wiki" do
        get :edit, id: public_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
      it "private wiki redirects to index" do
        get :edit, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

    describe "PUT update" do
      it "public wiki changes wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body, private: false}
        changed_wiki = assigns(:wiki)
        expect(changed_wiki.title).to eq new_title
        expect(changed_wiki.body).to eq new_body
      end
      it "public wiki redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body, private: false}
        expect(response).to redirect_to public_wiki
      end
      it "private wiki redirects to index" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to authenticated_root_path
      end
    end

    describe "DELETE destroy" do
      it "does not delete the public wiki" do
        delete :destroy, id: public_wiki.id
        count = Wiki.where({id: public_wiki.id}).size
        expect(count).to eq 1
      end
      it "public wiki returns http redirect" do
        delete :destroy, id: public_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
      it "does not delete the private wiki" do
        delete :destroy, id: private_wiki.id
        count = Wiki.where({id: private_wiki.id}).size
        expect(count).to eq 1
      end
      it "private wiki returns http redirect to index" do
        delete :destroy, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

  end # member user doing CRUD on wikis they don't own


  context "member user doing CRUD on a wiki they own" do

    before do
      @user = build(:user)
      @user.skip_confirmation!
      @user.save
      sign_in @user
      public_wiki.user = @user
      public_wiki.save
      private_wiki.user = @user
      private_wiki.save
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET show" do
      it "public wiki returns http success" do
        get :show, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "public wiki renders the #show view" do
        get :show, id: public_wiki.id
        expect(response).to render_template :show
      end
      it "public wiki assigns wiki to be shown to @public_wiki" do
        get :show, id: public_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
      it "private wiki redirects to index" do
        get :show, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

    describe "GET new" do
      it "wiki returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "wiki renders the #new view" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST create" do
      it "public wiki increases the number Wikis by 1" do
        expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Wiki, :count).by(1)
      end
      it "public wiki assigns the new wiki to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki) ).to eq Wiki.last
      end
      it "public wiki redirects to the new Wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to Wiki.last
      end
      it "public wiki expects :private to be false" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki).private ).to be_falsey
      end
      it "private wiki redirects to index" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}
        expect( response ).to redirect_to authenticated_root_path
      end
    end

    describe "GET edit" do
      it "public wiki returns http success" do
        get :edit, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end

      it "public wiki renders the #edit view" do
        get :edit, id: public_wiki.id
        expect(response).to render_template :edit
      end

      it "public wiki assigns wiki to be updated to @wiki" do
        get :edit, id: public_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end

      it "private wiki redirects to index" do
        get :edit, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

    describe "PUT update" do
      it "updates public wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq public_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated public wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to public_wiki
      end

      it "private wiki redirects to index" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to authenticated_root_path
      end
    end

    describe "DELETE destroy" do
      it "deletes the public wiki" do
        delete :destroy, id: public_wiki.id
        count = Wiki.where({id: public_wiki.id}).size
        expect(count).to eq 0
      end

      it "public wiki redirects to index" do
        delete :destroy, id: public_wiki.id
        expect(response).to redirect_to wikis_index_path
      end

      it "does not delete the private wiki" do
        delete :destroy, id: private_wiki.id
        count = Wiki.where({id: private_wiki.id}).size
        expect(count).to eq 1
      end

      it "private wiki redirects to index" do
        delete :destroy, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

  end # member user doing CRUD on wikis they own


  context "member user doing CRUD on a wiki as collaborator" do

    before do
      @user = create(:user)
      sign_in @user
      @other_user = create(:user, role: "premium")
      public_wiki.user = @other_user
      public_wiki.save
      private_wiki.user = @other_user
      private_wiki.save
      @collab = create(:collaborator, user:@user, wiki:private_wiki)
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(assigns(:wikis).count).to eq 2
      end
    end

    describe "GET show" do
      it "private wiki returns http success" do
        get :show, id: private_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "assigns wiki to be shown to @private_wiki" do
        get :show, id: private_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq private_wiki.id
        expect(wiki_instance.title).to eq private_wiki.title
        expect(wiki_instance.body).to eq private_wiki.body
      end
    end

    describe "GET edit" do
      it "private wiki returns http success" do
        get :edit, id: private_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "private wiki renders the #edit view" do
        get :edit, id: private_wiki.id
        expect(response).to render_template :edit
      end
      it "private wiki assigns wiki to be updated to @wiki" do
        get :edit, id: private_wiki.id
        wiki_instance = assigns(:wiki)
        expect(wiki_instance.id).to eq private_wiki.id
        expect(wiki_instance.title).to eq private_wiki.title
        expect(wiki_instance.body).to eq private_wiki.body
      end
    end

    describe "PUT update" do
      it "updates private wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq private_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end
      it "private wiki redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to private_wiki
      end
    end

    describe "DELETE destroy" do
      it "does not delete private wiki" do
        delete :destroy, id: private_wiki.id
        count = Wiki.where(id: private_wiki.id).size
        expect(count).to eq 1
      end
      it "private wiki returns http redirect to index" do
        delete :destroy, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

  end # member user doing CRUD on a wiki as collaborator


  context "premium user doing CRUD on a wikis they don't own" do

    before do
      @user = build(:user)
      @user.skip_confirmation!
      @user.premium!
      @user.save
      sign_in @user
      @other_user = build(:user)
      @other_user.skip_confirmation!
      @other_user.premium!
      @other_user.save
      public_wiki.user = @other_user
      public_wiki.save
      private_wiki.user = @other_user
      private_wiki.save
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET show" do
      it "public wiki returns http success" do
        get :show, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "public wiki renders the #show view" do
        get :show, id: public_wiki.id
        expect(response).to render_template :show
      end
      it "public wiki assigns wiki to be shown to @public_wiki" do
        get :show, id: public_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
      it "private wiki returns redirect to index" do
        get :show, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "renders the #new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe "POST create" do
      it "public wiki increases the number Wikis by 1" do
        expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Wiki, :count).by(1)
      end
      it "public wiki assigns the new wiki to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki) ).to eq Wiki.last
      end
      it "public wiki redirects to the new Wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to Wiki.last
      end
      it "public wiki expects :private to be false" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki).private ).to be_falsey
      end
      it "private wiki ignores user insertion" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @other_user}
        expect( assigns(:wiki).user ).to eq @user
      end
    end

    describe "GET edit" do
      it "public wiki returns http success" do
        get :edit, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "public wiki renders the #edit template" do
        get :edit, id: public_wiki.id
        expect(response).to render_template :edit
      end
      it "assigns public wiki to be updated to @wiki" do
        get :edit, id: public_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
      it "private wiki redirects to index" do
        get :edit, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

    describe "PUT update" do
      it "public wiki changes wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}
        changed_wiki = assigns(:wiki)
        expect(changed_wiki.title).to eq new_title
        expect(changed_wiki.body).to eq new_body
      end
      it "public wiki redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to public_wiki
      end
      it "private wiki redirects to index" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to authenticated_root_path
      end
    end

    describe "DELETE destroy" do
      it "public wiki returns http redirect" do
        delete :destroy, id: public_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
      it "private wiki returns http redirect to index" do
        delete :destroy, id: private_wiki.id
        expect(response).to redirect_to authenticated_root_path
      end
    end

  end # premium user doing CRUD on wikis they don't own


  context "premium user doing CRUD on a wiki they own" do

    before do
      @user = build(:user)
      @user.premium!
      @user.skip_confirmation!
      @user.save
      sign_in @user
      public_wiki.user = @user
      public_wiki.save
      private_wiki.user = @user
      private_wiki.save
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET show" do
      it "public wiki returns http success" do
        get :show, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "public wiki renders the #show view" do
        get :show, id: public_wiki.id
        expect(response).to render_template :show
      end
      it "public wiki assigns wiki to be shown to @public_wiki" do
        get :show, id: public_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
      it "private wiki returns http success" do
        get :show, id: private_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "private wiki renders the #show view" do
        get :show, id: private_wiki.id
        expect(response).to render_template :show
      end
      it "private wiki assigns wiki to be shown to @private_wiki" do
        get :show, id: private_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq private_wiki.id
        expect(wiki_instance.title).to eq private_wiki.title
        expect(wiki_instance.body).to eq private_wiki.body
      end
    end

    describe "GET new" do
      it "wiki returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "wiki renders the #new view" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST create" do
      it "public wiki increases the number Wikis by 1" do
        expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Wiki, :count).by(1)
      end
      it "public wiki assigns the new wiki to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki) ).to eq Wiki.last
      end
      it "public wiki redirects to the new Wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to Wiki.last
      end
      it "public wiki expects :private to be false" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki).private ).to be_falsey
      end
      it "private wiki increases the number Wikis by 1" do
        expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}}.to change(Wiki, :count).by(1)
      end
      it "private wiki assigns the new wiki to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}
        expect( assigns(:wiki) ).to eq Wiki.last
      end
      it "private wiki redirects to the new Wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "public wiki returns http success" do
        get :edit, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "public wiki renders the #edit view" do
        get :edit, id: public_wiki.id
        expect(response).to render_template :edit
      end
      it "public wiki assigns wiki to be updated to @wiki" do
        get :edit, id: public_wiki.id
        wiki_instance = assigns(:wiki)
        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
      it "private wiki returns http success" do
        get :edit, id: private_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "private wiki renders the #edit view" do
        get :edit, id: private_wiki.id
        expect(response).to render_template :edit
      end
      it "private wiki assigns wiki to be updated to @wiki" do
        get :edit, id: private_wiki.id
        wiki_instance = assigns(:wiki)
        expect(wiki_instance.id).to eq private_wiki.id
        expect(wiki_instance.title).to eq private_wiki.title
        expect(wiki_instance.body).to eq private_wiki.body
      end
    end

    describe "PUT update" do
      it "updates public wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq public_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end
      it "public wiki redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to public_wiki
      end
      it "updates private wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq private_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end
      it "updates private wiki to public and deletes collaborators" do
        collab_user = create( :user )
        collab = create(:collaborator, wiki: private_wiki, user: collab_user)
        expect{put :update, id: private_wiki.id, wiki: {private: false}}.to change(Collaborator, :count).by(-1)
      end
      it "private wiki redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to private_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the public wiki" do
        delete :destroy, id: public_wiki.id
        count = Wiki.where({id: public_wiki.id}).size
        expect(count).to eq 0
      end
      it "redirects to wikis index" do
        delete :destroy, id: public_wiki.id
        expect(response).to redirect_to wikis_index_path
      end
      it "deletes the private wiki" do
        delete :destroy, id: private_wiki.id
        count = Wiki.where({id: private_wiki.id}).size
        expect(count).to eq 0
      end
      it "redirects to wikis index" do
        delete :destroy, id: private_wiki.id
        expect(response).to redirect_to wikis_index_path
      end
    end

  end # premium user doing CRUD on a wiki they own


  context "admin user doing CRUD on any wiki" do

    before do
      @user = build(:user)
      @user.admin!
      @user.skip_confirmation!
      @user.save
      sign_in @user
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET show" do
      it "public wiki returns http success" do
        get :show, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "public wiki renders the #show view" do
        get :show, id: public_wiki.id
        expect(response).to render_template :show
      end
      it "public wiki assigns wiki to be shown to @public_wiki" do
        get :show, id: public_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
      it "private wiki returns http success" do
        get :show, id: private_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "private wiki renders the #show view" do
        get :show, id: private_wiki.id
        expect(response).to render_template :show
      end
      it "private wiki assigns wiki to be shown to @private_wiki" do
        get :show, id: private_wiki.id
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq private_wiki.id
        expect(wiki_instance.title).to eq private_wiki.title
        expect(wiki_instance.body).to eq private_wiki.body
      end
    end

    describe "GET new" do
      it "wiki returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "wiki renders the #new view" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST create" do
      it "public wiki increases the number Wikis by 1" do
        expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Wiki, :count).by(1)
      end
      it "public wiki assigns the new wiki to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki) ).to eq Wiki.last
      end
      it "public wiki redirects to the new Wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to Wiki.last
      end
      it "public wiki expects :private to be false" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect( assigns(:wiki).private ).to be_falsey
      end
      it "private wiki increases the number Wikis by 1" do
        expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}}.to change(Wiki, :count).by(1)
      end
      it "private wiki assigns the new wiki to @wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}
        expect( assigns(:wiki) ).to eq Wiki.last
      end
      it "private wiki redirects to the new Wiki" do
        post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "public wiki returns http success" do
        get :edit, id: public_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "public wiki renders the #edit view" do
        get :edit, id: public_wiki.id
        expect(response).to render_template :edit
      end
      it "public wiki assigns wiki to be updated to @wiki" do
        get :edit, id: public_wiki.id
        wiki_instance = assigns(:wiki)
        expect(wiki_instance.id).to eq public_wiki.id
        expect(wiki_instance.title).to eq public_wiki.title
        expect(wiki_instance.body).to eq public_wiki.body
      end
      it "private wiki returns http success" do
        get :edit, id: private_wiki.id
        expect(response).to have_http_status(:success)
      end
      it "private wiki renders the #edit view" do
        get :edit, id: private_wiki.id
        expect(response).to render_template :edit
      end
      it "private wiki assigns wiki to be updated to @wiki" do
        get :edit, id: private_wiki.id
        wiki_instance = assigns(:wiki)
        expect(wiki_instance.id).to eq private_wiki.id
        expect(wiki_instance.title).to eq private_wiki.title
        expect(wiki_instance.body).to eq private_wiki.body
      end
    end

    describe "PUT update" do
      it "updates public wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq public_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end
      it "public wiki redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: public_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to public_wiki
      end
      it "updates private wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq private_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end
      it "private wiki redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to private_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the public wiki" do
        delete :destroy, id: public_wiki.id
        count = Wiki.where({id: public_wiki.id}).size
        expect(count).to eq 0
      end
      it "redirects to wikis index" do
        delete :destroy, id: public_wiki.id
        expect(response).to redirect_to wikis_index_path
      end
      it "deletes the private wiki" do
        delete :destroy, id: private_wiki.id
        count = Wiki.where({id: private_wiki.id}).size
        expect(count).to eq 0
      end
      it "redirects to wikis index" do
        delete :destroy, id: private_wiki.id
        expect(response).to redirect_to wikis_index_path
      end
    end

  end # member user doing CRUD on a public wiki they own


end
