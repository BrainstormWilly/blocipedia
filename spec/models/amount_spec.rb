require 'rails_helper'

RSpec.describe Amount, type: :model do

  describe "self.default method" do
    it "is $15 by default" do
      expect(Amount.default).to be(1500)
    end
  end
  
end
