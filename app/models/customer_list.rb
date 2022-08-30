class CustomerList < ApplicationRecord
  has_one_attached :list
  before_validation :set_filename
  validate :list_attached
  validate :list_is_of_valid_type
  validates :filename, uniqueness: true

  private

  SUPPORTED_LIST_FILE_TYPE = "txt".freeze

  def list_attached
    errors.add(:list, "must be attached") unless list.attached?
  end

  def list_is_of_valid_type
    unless filename.match?(/\.#{Regexp.quote(SUPPORTED_LIST_FILE_TYPE)}\z/i)
      errors.add(:list, "must be of file type #{SUPPORTED_LIST_FILE_TYPE}")
    end
  end

  def set_filename
    self.filename = list.attached? ? list.filename.sanitized : ""
  end
end
