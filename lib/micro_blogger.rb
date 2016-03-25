require 'jumpstart_auth'

class MicroBlogger
  MSG_LEN_LIM = 140
  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
    if message.length <= MSG_LEN_LIM
      @client.update(message)  
    else
      puts "Can't post more than 140 characters..."  
    end
  end

  def followers_list
    @client.followers.collect { |follower| @client.user(follower).screen_name }
  end

  def is_follower?(target)
    screen_names = followers_list
    screen_names.include? target
  end

  def dm(target, message)
    if is_follower? target
      puts "Trying to send #{target} this direct message:"
      puts message
      message = "d @#{target} #{message}"
      tweet(message)
    else
      puts "Sorry this person doesn't follow you..."
    end 
  end

  def spam_my_followers(message)
    followers = followers_list
    followers.each { |follower| dm(follower, message) }
  end

  def everyones_last_tweet
    friends = @client.friends.collect{ |id| @client.user(id) }.sort_by { |friend| friend.screen_name.downcase }
    friends.each do |friend|
      timestamp = friend.status.created_at
      puts "#{friend.screen_name} said this on #{timestamp.strftime("%A, %b %d")
}..."
      puts "\t #{friend.status.text}"
    end
  end


  def run
    puts "Welcome to the JSL Twitter Client!"
    command = ""
    while command != "q"
      printf "enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]

      case command
      when 'q' then puts "Goodbye!"
      when 't' then tweet(parts[1..-1].join(" "))
      when 'dm' then dm(parts[1], parts[2..-1].join(" "))
      when 'spam' then spam_my_followers(parts[1..-1].join(" "))
      when 'elt' then everyones_last_tweet
      else
        puts "Sorry, I don't know how to #{command}"
      end
    end
  end
end

blogger = MicroBlogger.new
blogger.run

