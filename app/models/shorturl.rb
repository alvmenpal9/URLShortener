class Shorturl < ApplicationRecord
  VALID_REGEX = /\A[a-zA-Z0-9]{5}\z/
  validates :original_url, presence: true, url: true, uniqueness: true
  validates :short_url, presence: true, uniqueness: true, length: {minimum: 5, maximum:5}, format: { with: VALID_REGEX }
end
