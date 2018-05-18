require "twitter"
require "dotenv"

Dotenv.load

nagatech_client = Twitter::REST::Client.new do |config|
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


old = 0
begin
  File.open('./old_id.txt',"r") do |file|
    file.each_line do |old_id|
      old = old_id.to_i
    end
  end
  # puts("old = #{old}")
rescue SystemCallError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
rescue IOError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
end

random = Random.new
is_first = true

query = "#ながてちキャンペーン"

nagatech_client.search(query, result_type: "recent",  exclude: "retweets").each do |tweet|
  if (is_first)
    begin
      File.open("./old_id.txt", "w") do |f| 
        f.puts(tweet.id.to_s)
      end
    rescue SystemCallError => e
      puts %Q(class=[#{e.class}] message=[#{e.message}])
    rescue IOError => e
      puts %Q(class=[#{e.class}] message=[#{e.message}])
    end
    is_first = false
  end

  po = tweet.id.to_i
  break if po == old
  number = random.rand(0..33)
    if number == 0
      hantei = "atari"
      cheese_client.update("@syobon_titech\n@#{tweet.user.screen_name} さんが当選しました")      
    else
      hantei = "hazure"
    end
    nagatech_client.update_with_media("@#{tweet.user.screen_name}\nご応募ありがとうございます！\n気になる抽選の結果は…！？\n当選するまで何度でも挑戦できますよ♪\n6/14（木）23:59まで！\n\nキャンペーンの詳しい詳細はこちらから！\nhttps://blog.nagatech.work/nagatech-campaign\n", File.open("./res/#{hantei}.png"), options = {:in_reply_to_status_id => tweet.id})
end

