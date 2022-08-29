require 'rails_helper'

RSpec.describe CustomerRecord, type: :model do
  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:vehicle_type) }
    it { should validate_numericality_of(:vehicle_length).is_greater_than_or_equal_to(0) }
  end
end
