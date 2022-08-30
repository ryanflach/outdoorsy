require 'rails_helper'

RSpec.describe CustomerList, type: :model do
  describe "validations" do
    it { should have_one_attached(:list) }
    it { should have_many(:customer_records).dependent(:destroy) }

    context "list file types" do
      let(:some_unsupported_file_types) { %w(csv doc pdf xlsx) }

      it "does not accept unsupported file types" do
        random_invalid_type = some_unsupported_file_types.sample

        invalid_record = CustomerList.new()
        invalid_record.list.attach(
          io: File.open(Rails.root.join("spec", "test_data", "invalid.#{random_invalid_type}")),
          filename: "invalid.#{random_invalid_type}"
        )

        expect(invalid_record.valid?).to eq(false)
        expect(invalid_record.errors.full_messages).to include("List must be of file type txt")
      end
    end

    context "filename" do
      let(:existing_list) { create(:customer_list) }

      it "is set by the attached list" do
        expect(existing_list.filename).to eq("commas.txt")
      end

      it "enforces uniqueness" do
        duplicate_filename = build(:customer_list, filename: existing_list.filename)

        expect(duplicate_filename.valid?).to eq(false)
        expect(duplicate_filename.errors.full_messages).to include("Filename has already been taken")
      end
    end
  end
end
