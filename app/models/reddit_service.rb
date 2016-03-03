class RedditService
  def get(subreddit, filter, params)
    uri = URI("http://www.reddit.com/r/#{subreddit}/#{filter}.json?#{params}")
      req = Net::HTTP::Get.new(uri)
      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }
    JSON.parse(res.body)
  end

  def process(reddit_reply)
    posts = reddit_reply["data"]["children"].map do |post_json|
      build_post(post_json["data"])
    end

      {
       children: posts,
         before: reddit_reply["data"]["before"],
          after: reddit_reply["data"]["after"]
      }
  end

  def process_single(subreddit, filter, params)
    process(get(subreddit, filter, params))
  end

  def process_many(subreddit, filter, count)
    i, posts = 1, []
    reply = process_single(subreddit, filter, "limit=100")
    posts += reply[:children]
    while posts.count < count do
      reply = process_single(subreddit, filter, "limit=100&after=#{reply[:after]}")
      posts += reply[:children]
      puts i+=1
    end
    posts
  end

private

  def build_post(post_params)
    OpenStruct.new(post_params)
  end

end
