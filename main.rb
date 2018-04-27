require "twitter"
require "dotenv"

Dotenv.load

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["MY_CONSUMER_KEY"]
  config.consumer_secret     = ENV["MY_CONSUMER_SECRET"]
  config.access_token        = ENV["MY_ACCESS_TOKEN"]
  config.access_token_secret = ENV["MY_ACCESS_TOKEN_SECRET"]
end

stream_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["MY_CONSUMER_KEY"]
  config.consumer_secret     = ENV["MY_CONSUMER_SECRET"]
  config.access_token        = ENV["MY_ACCESS_TOKEN"]
  config.access_token_secret = ENV["MY_ACCESS_TOKEN_SECRET"]
end

stream_client.filter(track: "#てすと") do |tweet|
  if tweet.is_a?(Twitter::Tweet)
    client.update("@#{tweet.user.screen_name}\npo", options = {:in_reply_to_status_id => tweet.id})
  end
end
