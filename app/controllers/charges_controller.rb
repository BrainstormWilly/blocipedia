class ChargesController < ApplicationController

  before_action :authenticate_user!

  def new
     @stripe_btn_data = {
       key: "#{ Rails.configuration.stripe[:publishable_key] }",
       description: "Premium Membership",
       amount: Amount.default
     }
  end

  def create
   customer = Stripe::Customer.create(
     email: current_user.email,
     card: stripe_params
   )

   # Where the real magic happens
   charge = Stripe::Charge.create(
     customer: customer.id, # Note -- this is NOT the user_id in your app
     amount: Amount.default,
     description: "Blocipedia Premium Membership",
     currency: 'usd'
   )

   current_user.premium!
   if current_user.save
     flash[:notice] = "Thanks #{current_user.name}! Happy wikiing."
   else
     flash[:alert] = "Sorry, we could not upgrade your account. Please contact us."
   end
   redirect_to root_path


   # Stripe will send back CardErrors, with friendly messages
   # when something goes wrong.
   # This `rescue block` catches and displays those errors.
   rescue Stripe::CardError => e
     flash[:alert] = e.message
     redirect_to new_charge_path

  end


  private

  def stripe_params
    params.require(:stripeToken)
  end

end
