require 'rails_helper'

RSpec.describe ChargesController, type: :controller do

  context "guest user" do

    describe "GET #new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST #create" do
      it "returns http redirect" do
        post :create, stripeToken: "e33er089dv89089e7ripoqewur089qe7rpqiewur"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  context "member user" do

    before do
      # @stripe_btn_data = {
      #   key: "#{ Rails.configuration.stripe[:publishable_key] }",
      #   description: "Premium Membership",
      #   amount: Amount.default
      # }

      @user = build(:user)
      @user.skip_confirmation!
      @user.save
      sign_in @user
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "renders the #new view" do
        get :new, id: @user.id
        expect(response).to render_template :new
      end
    end

    # POST handled by GEM 'stripe'

  end

end
