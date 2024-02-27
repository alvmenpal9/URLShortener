require 'rails_helper'

RSpec.describe Shorturl, type: :model do
  it "sends an invalid url" do
    test_url = Shorturl.create(original_url:"httpsas://www.test.com", short_url:"asJc5")
    expect {test_url.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Original url is not a valid URL")
  end

  it "sends a blank url" do
    test_url = Shorturl.create(original_url:"", short_url:"asJc5")
    expect {test_url.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Original url can't be blank, Original url is not a valid URL")
  end

  it "sends an existing original url" do
    test_url = Shorturl.create(original_url:"https://www.test.com", short_url:"asJc5")
    existing_url = Shorturl.new(original_url:"https://www.test.com", short_url:"asd12")
    expect {existing_url.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Original url has already been taken")
  end

  it "tries to save an existing shortened url" do
    test_url = Shorturl.create(original_url:"https://www.test.com", short_url:"asJc5")
    existing_url = Shorturl.new(original_url:"https://www.test123.com", short_url:"asJc5")
    expect {existing_url.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Short url has already been taken")
  end

  it "tries to save a shortened url with more than 5 characters" do
    test_url = Shorturl.create(original_url:"https://www.test.com", short_url:"asJc5a")
    expect {test_url.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Short url is too long (maximum is 5 characters), Short url is invalid")
  end

  it "tries to save a shortened url with less than 5 characters" do
    test_url = Shorturl.create(original_url:"https://www.test.com", short_url:"asJc")
    expect {test_url.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Short url is too short (minimum is 5 characters), Short url is invalid")
  end

  it "tries to save a shortened url with special characters" do
    test_url = Shorturl.create(original_url:"https://www.test.com", short_url:"asJ*c")
    expect {test_url.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Short url is invalid")
  end

  it "saves the shortened url" do
    test_url = Shorturl.create(original_url:"https://www.test.com", short_url: "544cD")
    expect {test_url.save!}.not_to raise_error

    expect(Shorturl.last).to eq(test_url)
  end
end
