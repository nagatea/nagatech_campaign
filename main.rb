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

random = Random.new

stream_client.filter(track: "#てすと") do |tweet|
  if tweet.is_a?(Twitter::Tweet)
    number = random.rand(0..2)
    if number == 0
      hantei = "atari"
    else
      hantei = "hazure"
    end
    client.update_with_media("@#{tweet.user.screen_name}\nご応募ありがとうございます！\n気になる抽選の結果は…！？\n当選するまで何度でも挑戦できますよ♪\n5/31（木）23:59まで！\nrandom = #{number}\n", File.open("./res/#{hantei}.png"), options = {:in_reply_to_status_id => tweet.id})
  end
end
