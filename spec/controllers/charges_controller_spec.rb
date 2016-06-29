require 'rails_helper'

RSpec.describe ChargesController, type: :controller do

  context "guest user" do

    describe "GET #new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end


  context "member user" do

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user)
      @user.confirm
      sign_in @user
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

  end

end
