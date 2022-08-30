require 'rails_helper'

RSpec.describe CustomerList, type: :model do
  describe "validations" do
    it { should validate_uniqueness_of(:filename) }
    it { should have_one_attached(:list) }
    it { should allow_value("hello.txt").for(:filename) }
    it do
      should_not allow_values("hello.csv", "hello.xlsx")
                 .for(:filename)
                 .with_message("must be txt file type")
    end
  end
end
