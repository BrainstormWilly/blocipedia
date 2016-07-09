require 'rails_helper'

RSpec.describe UsersController, type: :controller do


  context "guest user" do

    before do
      @user = build(:user)
      @user.skip_confirmation!
      @user.save
    end

    describe "GET #show" do
      it "returns http redirect" do
        get :show, id: @user.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #edit" do
      it "returns http redirect" do
        get :edit, id: @user.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "PUT #update" do
      it "returns http redirect" do
        new_name = Faker::Name.name
        new_email = Faker::Internet.email
        put :update, id: @user.id, user: {name: new_name, email: new_email}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    # destroy, create handled by Devise GEM

  end


  context "member user" do

    before do
      @user = build(:user)
      @user.skip_confirmation!
      @user.save
      sign_in @user
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, id: @user.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        get :edit, id: @user.id
        expect(response).to have_http_status(:success)
      end
      it "renders the #edit view" do
        get :edit, id: @user.id
        expect(response).to render_template :edit
      end
    end

    describe "PUT update" do
      it "updates user with expected attributes" do
        new_name = Faker::Name.name
        new_email = Faker::Internet.email

        put :update, id: @user.id, user: {name: new_name, email: new_email, role:"member"}

        updated_user = assigns(:user)
        expect(updated_user.id).to eq @user.id
        expect(updated_user.name).to eq new_name
        expect(updated_user.email).to eq new_email
        expect(updated_user.role).to eq "member"
      end

      it "redirects to the updated user" do
        new_name = Faker::Name.name
        new_email = Faker::Internet.email

        put :update, id: @user.id, user: {name: new_name, email: new_email, role: "member"}
        expect(response).to redirect_to @user
      end
    end

    # destroy, create handled by Devise GEM

  end


  context "premium user" do

    before do
      @user = build(:user)
      @user.skip_confirmation!
      @user.premium!
      @user.save
      sign_in @user
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, id: @user.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        get :edit, id: @user.id
        expect(response).to have_http_status(:success)
      end
      it "renders the #edit view" do
        get :edit, id: @user.id
        expect(response).to render_template :edit
      end
    end

    describe "PUT update name, email, and role" do
      it "updates user with expected attributes" do
        new_name = Faker::Name.name
        new_email = Faker::Internet.email

        put :update, id: @user.id, user: {name: new_name, email: new_email, role:"premium"}

        updated_user = assigns(:user)
        expect(updated_user.id).to eq @user.id
        expect(updated_user.name).to eq new_name
        expect(updated_user.email).to eq new_email
        expect(updated_user.role).to eq "premium"
      end

      it "redirects to the updated user" do
        new_name = Faker::Name.name
        new_email = Faker::Internet.email

        put :update, id: @user.id, user: {name: new_name, email: new_email, role: "premium"}

        expect(response).to redirect_to @user
      end

      it "assigns new name, email" do
        new_name = Faker::Name.name
        new_email = Faker::Internet.email

        put :update, id: @user.id, user: {name: new_name, email: new_email, role: "premium"}
        expect( assigns(:user).name ).to eq new_name
        expect( assigns(:user).email ).to eq new_email
      end

      it "downgrades user to member" do
        put :update, id: @user.id, user: {name: @user.name, email: @user.email, role: "member"}
        expect( assigns(:user).role ).to eq "member"
      end

      it "converts private wikis to public after downgrade" do
        create(:wiki, title: "My Private Wiki", user: @user, private:true)
        put :update, id: @user.id, user: {name: @user.name, email: @user.email, role: "member"}
        expect( @user.wikis.last.private ).to be_falsey
      end
    end

    # destroy, create handled by Devise GEM

  end

end
