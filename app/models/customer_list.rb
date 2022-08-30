class CustomerList < ApplicationRecord
  has_one_attached :list
  validates :filename, uniqueness: true, format: { with: /.txt\z/, message: "must be txt file type" }
  validate :list_attached

  private

  def list_attached
    return if list.attached?

    errors.add(:list, "must be attached")
  end
end
