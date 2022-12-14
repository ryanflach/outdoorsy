class CustomerList < ApplicationRecord
  has_one_attached :list
  has_many :customer_records, dependent: :destroy

  before_validation :set_filename, on: :create
  validate :list_attached
  validate :list_is_of_valid_type
  validates :filename, uniqueness: true

  def num_records
    customer_records.count
  end

  def process_list
    CustomerListProcessor.process_list(self, list_file_path)
    self
  end

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

  def list_file_path
    ActiveStorage::Blob.service.path_for(list.key)
  end
end
