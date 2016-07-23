require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do

  let( :owner ){ create(:user, role: "premium") }
  let( :wiki ){ create(:wiki, private: true, user: owner) }

  context "guest user" do

    describe "GET index" do
      it "returns http redirect" do
        get :index, wiki_id: wiki.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST create" do
      it "does not change collaborators count" do
        collab_user = create(:user)
        expect{post :create, wiki_id: wiki.id, id: collab_user.id}.to change(Collaborator, :count).by(0)
      end
      it "returns http redirect" do
        collab_user = create(:user)
        post :create, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE destroy" do
      it "does not delete collaborator" do
        collab_user = create(:user)
        collab = Collaborator.create(wiki: wiki, user: collab_user)
        delete :destroy, wiki_id: wiki.id, id: collab_user.id
        count = Collaborator.where(id: collab.id).count
        expect(count).to eq 1
      end
      it "returns http redirect" do
        collab_user = create(:user)
        collab = create(:collaborator, wiki: wiki, user: collab_user)
        delete :destroy, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end # end guest user context


  context "member user who is not a collaborator" do

    before do
      @other_user = create(:user)
      sign_in @other_user
    end

    describe "GET index" do
      it "returns http redirect" do
        get :index, wiki_id: wiki.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    describe "POST create" do
      it "does not change collaborators count" do
        collab_user = create(:user)
        expect{post :create, wiki_id: wiki.id, id: collab_user.id}.to change(Collaborator, :count).by(0)
      end
      it "returns http redirect" do
        collab_user = create(:user)
        post :create, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    describe "DELETE destroy" do
      it "does not delete collaborator" do
        collab_user = create(:user)
        collab = Collaborator.create(wiki: wiki, user: collab_user)
        delete :destroy, wiki_id: wiki.id, id: collab_user.id
        count = Collaborator.where(id: collab.id).count
        expect(count).to eq 1
      end
      it "returns http redirect" do
        collab_user = create(:user)
        collab = create(:collaborator, wiki: wiki, user: collab_user)
        delete :destroy, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

  end # member user who is not a collaborator


  context "member user who is a collaborator" do

    before do
      @collab_user = create( :user )
      sign_in @collab_user
    end

    describe "GET index" do
      it "returns http redirect" do
        get :index, wiki_id: wiki.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    describe "POST create" do
      it "does not change collaborators count" do
        expect{post :create, wiki_id: wiki.id, id: @collab_user.id}.to change(Collaborator, :count).by(0)
      end
      it "returns http redirect" do
        post :create, wiki_id: wiki.id, id: @collab_user.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    describe "DELETE destroy" do
      it "does not delete collaborator" do
        collab = Collaborator.create(wiki: wiki, user: @collab_user)
        delete :destroy, wiki_id: wiki.id, id: @collab_user.id
        count = Collaborator.where(id: collab.id).count
        expect(count).to eq 1
      end
      it "returns http redirect" do
        collab_user = create(:user)
        collab = create(:collaborator, wiki: wiki, user: @collab_user)
        delete :destroy, wiki_id: wiki.id, id: @collab_user.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

  end # member user who is a collaborator


  context "premium user who doesn't own wiki and is not a collaborator" do

    before do
      @prem_user = create(:user, role: "premium")
      sign_in @prem_user
    end

    describe "GET index" do
      it "returns http redirect" do
        get :index, wiki_id: wiki.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    describe "POST create" do
      it "does not change collaborators count" do
        collab_user = create(:user)
        expect{post :create, wiki_id: wiki.id, id: collab_user.id}.to change(Collaborator, :count).by(0)
      end
      it "returns http redirect" do
        collab_user = create(:user)
        post :create, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    describe "DELETE destroy" do
      it "does not delete collaborator" do
        collab_user = create(:user)
        collab = Collaborator.create(wiki: wiki, user: collab_user)
        delete :destroy, wiki_id: wiki.id, id: collab_user.id
        count = Collaborator.where(id: collab.id).count
        expect(count).to eq 1
      end
      it "returns http redirect" do
        collab_user = create(:user)
        collab = create(:collaborator, wiki: wiki, user: collab_user)
        delete :destroy, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

  end # premium user who doesn't own wiki and is not a collaborator



  context "premium user who is collaborator" do

    before do
      @prem_user = create(:user, role: "premium")
      sign_in @prem_user
    end

    describe "GET index" do
      it "returns http redirect" do
        get :index, wiki_id: wiki.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    describe "POST create" do
      it "does not change collaborators count" do
        expect{post :create, wiki_id: wiki.id, id: @prem_user.id}.to change(Collaborator, :count).by(0)
      end
      it "returns http redirect" do
        post :create, wiki_id: wiki.id, id: @prem_user.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    describe "DELETE destroy" do
      it "does not delete collaborator" do
        collab = Collaborator.create(wiki: wiki, user: @prem_user)
        delete :destroy, wiki_id: wiki.id, id: @prem_user.id
        count = Collaborator.where(id: collab.id).count
        expect(count).to eq 1
      end
      it "returns http redirect" do
        collab_user = create(:user)
        collab = create(:collaborator, wiki: wiki, user: @prem_user)
        delete :destroy, wiki_id: wiki.id, id: @prem_user.id
        expect(response).to redirect_to(authenticated_root_path)
      end
    end


  end # premium user who doesn't own wiki



  context "premium user who owns wiki" do

    before do
      request.env["HTTP_REFERER"] = wiki_collaborators_path(wiki)
      sign_in owner
    end

    describe "GET index" do
      it "shows users" do
        another_user = create( :user )
        get :index, wiki_id: wiki.id
        expect(assigns(:users).count).to be > 0
      end
      it "renders collaborators index" do
        get :index, wiki_id: wiki.id
        expect(response).to render_template(:index)
      end
    end

    describe "POST create" do
      it "increases collaborators by 1" do
        collab_user = create( :user )
        expect{post :create, wiki_id: wiki.id, id: collab_user.id}.to change(Collaborator, :count).by(1)
      end
      it "redirects back to collaborators index" do
        collab_user = create( :user )
        post :create, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(wiki_collaborators_path)
      end
    end

    describe "DELETE destroy" do
      it "deletes collaborator" do
        collab_user = create( :user )
        collab = create( :collaborator, wiki: wiki, user: collab_user)
        expect{delete :destroy, wiki_id: wiki.id, id: collab_user.id}.to change(Collaborator, :count).by(-1)
      end
      it "redirects to collaborators index" do
        collab_user = create( :user )
        collab = create( :collaborator, wiki: wiki, user: collab_user)
        delete :destroy, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(wiki_collaborators_path)
      end
    end

  end # premium user who owns wiki


  context "admin user" do

    before do
      request.env["HTTP_REFERER"] = wiki_collaborators_path(wiki)
      @admin_user = create(:user, role: "admin")
      sign_in @admin_user
    end

    describe "GET index" do

      it "shows users" do
        get :index, wiki_id: wiki.id
        expect(assigns(:users).count).to be > 0
      end
      it "renders collaborators index" do
        get :index, wiki_id: wiki.id
        expect(response).to render_template(:index)
      end
    end

    describe "POST create" do
      it "increases collaborators by 1" do
        collab_user = create(:user)
        expect{post :create, wiki_id: wiki.id, id: collab_user.id}.to change(Collaborator, :count).by(1)
      end
      it "redirects back to collaborators index" do
        collab_user = create(:user)
        post :create, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(wiki_collaborators_path)
      end
    end

    describe "DELETE destroy" do
      it "deletes collaborator" do
        collab_user = create(:user)
        collab = create(:collaborator, wiki: wiki, user: collab_user)
        delete :destroy, wiki_id: wiki.id, id: collab_user.id
        count = Collaborator.where(id: collab.id).count
        expect(count).to eq 0
      end
      it "redirects to collaborators index" do
        collab_user = create(:user)
        collab = create(:collaborator, wiki: wiki, user: collab_user)
        delete :destroy, wiki_id: wiki.id, id: collab_user.id
        expect(response).to redirect_to(wiki_collaborators_path)
      end
    end

  end # admin user





end
