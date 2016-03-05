class RedditMiner
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

  def process_many(subreddit, filter, api_calls, start_at = nil)
    posts, initial_params = [], "limit=100"
    initial_params += "&after=#{start_at}" if start_at
    reply = process_single(subreddit, filter, initial_params)
    posts += reply[:children]
    (api_calls-1).times do |i|
      puts i
      reply = process_single(subreddit, filter, "limit=100&after=#{reply[:after]}")
      posts += reply[:children]
    end
    {posts: posts.uniq, continue_at: reply[:after]}
  end

  def build_post(post_params)
    OpenStruct.new(post_params)
  end
end
