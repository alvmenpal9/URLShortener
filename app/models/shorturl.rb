class Shorturl < ApplicationRecord
  validates :original_url, presence: true, url: true, uniqueness: true
  validates :short_url, presence: true, uniqueness: true, length: {maximum:5}
end
