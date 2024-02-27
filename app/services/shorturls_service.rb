class ShorturlsService
  @result = {}

  def self.create_short_url(original_url)
    # Generate short url
    shortened = generate_short

    # We create the url information
    result = Shorturl.new(original_url:original_url, short_url:shortened)
    result.save!
    result
  end

  def self.return_url(url)
    if url.length != 5
        @result[:status] = false
        @result[:message] = "invalid url"
        return @result
    end

    found_url = Shorturl.find_by(short_url: url)
    if found_url
      visits = found_url.visits + 1
      found_url.update!(visits: visits)
      @result[:status] = true
      @result[:url] = found_url
    else
      @result[:status] = false
      @result[:message] = "url not found"
    end

    @result
  end

  private
  def self.generate_short
    characters = (("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a).shuffle
    random_url = ""
    for i in 1..5
      random_url += characters[i]
    end

    # We check if the shortened url was previously generated, if it was, then a new one is generated
    already_exists = Shorturl.find_by(short_url:random_url)
    already_exists ? generate_short : random_url
  end
end
