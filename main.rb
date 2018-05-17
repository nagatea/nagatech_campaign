require "twitter"
require "./time.rb"
#require "dotenv"

#Dotenv.load

nagatech_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["MY_CONSUMER_KEY"]
  config.consumer_secret     = ENV["MY_CONSUMER_SECRET"]
  config.access_token        = ENV["MY_ACCESS_TOKEN"]
  config.access_token_secret = ENV["MY_ACCESS_TOKEN_SECRET"]
end

nagatech_stream_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["MY_CONSUMER_KEY"]
  config.consumer_secret     = ENV["MY_CONSUMER_SECRET"]
  config.access_token        = ENV["MY_ACCESS_TOKEN"]
  config.access_token_secret = ENV["MY_ACCESS_TOKEN_SECRET"]
end

cheese_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["MY_CONSUMER_KEY2"]
  config.consumer_secret     = ENV["MY_CONSUMER_SECRET2"]
  config.access_token        = ENV["MY_ACCESS_TOKEN2"]
  config.access_token_secret = ENV["MY_ACCESS_TOKEN_SECRET2"]
end

retry_count ||= 0

begin
  random = Random.new

  nagatech_stream_client.filter(track: "#ながてちキャンペーン") do |tweet|
    if tweet.is_a?(Twitter::Tweet)
      number = random.rand(0..33)
      if number == 0
        hantei = "atari"
        cheese_client.update("@syobon_titech\n@#{tweet.user.screen_name} さんが当選しました")      
      else
        hantei = "hazure"
      end
      nagatech_client.update_with_media("@#{tweet.user.screen_name}\nご応募ありがとうございます！\n気になる抽選の結果は…！？\n当選するまで何度でも挑戦できますよ♪\n6/14（木）23:59まで！\n\nキャンペーンの詳しい詳細はこちらから！\nhttps://blog.nagatech.work/nagatech-campaign\n", File.open("./res/#{hantei}.png"), options = {:in_reply_to_status_id => tweet.id})
    end
  end
rescue => exception
  retry_conut += 1
  if retry_conut < 7
    #client2.update("エラー発生(リトライ回数#{retry_conut}回目)\n#{exception.message}\n#{JSTTime.timecode}")
    puts("エラー発生(リトライ回数#{retry_conut}回目)\n#{exception.message}\n#{exception.backtrace}\n#{JSTTime.timecode}")
    retry if retry_conut < 7
  else
    client.update("@syobon_titech\nエラー発生\nリトライ回数が規定回数を超えたので強制終了します。\n#{exception.message}\n#{JSTTime.timecode}")
  end
end
