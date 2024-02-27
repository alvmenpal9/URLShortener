require 'rails_helper'

RSpec.describe "Shorturls", type: :request do
  describe "GET #show" do
    context "when record exists" do
      it "returns the shortened url" do
        test_url = Shorturl.create(original_url:"https://www.test.com", short_url:"12aFa")
        get "/api/v1/#{test_url.short_url}"
        expect(response).to have_http_status(:success)
      end
    end

    context "when record does not exist" do
      it "returns a 404 HTTP response" do
        get "/api/v1/asdSt"
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("url not found")
      end
    end

    context "when url is invalid" do
      it "returns a 404 HTTP response" do
        get "/api/v1/ast"
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("invalid url")
      end
    end
  end

  describe "GET #index" do
    it "returns all records" do
      url_1 = Shorturl.create(original_url:"https://www.test.com", short_url:"12aFa")
      url_2 = Shorturl.create(original_url:"https://www.test2.com", short_url:"12aFb")
      get "/api/v1/shorturls"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a shortened url" do
        expect {
          post "/api/v1/shorturls", params: {original_url: "https://www.test.com"}
      }.to change(Shorturl, :count).from(0).to(1)

      expect(response).to have_http_status(:created)
      end
    end

    context "with an existing original url" do
      it "returns a 422 HTTP message" do
        existing_url = Shorturl.create(original_url:"https://www.test.com", short_url:"e54cA")
        post "/api/v1/shorturls", params: {original_url: "#{existing_url.original_url}"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Validation failed: Original url has already been taken")
      end
    end

    context "with invalid attributes" do
      it "returns a 422 HTTP message" do
        post "/api/v1/shorturls", params: {original_url: "htasd://www.test.com"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Validation failed: Original url is not a valid URL")
      end
    end
  end


end
