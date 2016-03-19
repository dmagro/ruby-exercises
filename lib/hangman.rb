class Hangman

  MIN_LEN = 5
  MAX_LEN = 12
  OUTPUT_MSGS = { 
    ask_for_file: "There is no such file. Do you know where is the dictionary?",
    file_not_found: "Nope, file also not found. Exiting...",
    no_dict: "No dictionary available. Exiting...",
    lose_msg: ", sorry mate..."
  }

  attr_reader :dictionary, :secret_word
  attr_accessor :dictionary_path

  def initialize(dictionary_path)
    @dictionary_path = dictionary_path
    load_dictionary()
    choose_word()
    @guess_fails = 0
  end
  
  public

  def play_game()
    #GAME INTERPRETER
  end

  private
  def game_reset()
    choose_word
    @guess_fails = 0
  end

  def valid_word?(word)
    word.length.between?(MIN_LEN, MAX_LEN)
  end

  def ask_for_file()
    puts OUTPUT_MSGS[:ask_for_file]
    file_path = gets.chomp.tr(" \t\n", '')
  end

  def load_dictionary()
    @dictionary = {}
    begin
      filename = File.open(@dictionary_path, "r")
      filename.readlines.inject(@dictionary){ |hash,line| word = line.chomp.downcase; hash[word.to_sym] = word if valid_word?(word); hash}
      filename.close
    rescue Errno::ENOENT
      file_path = ask_for_file()
      if File.exists? file_path
        @dictionary_path = file_path
        retry
      else
        puts OUTPUT_MSGS[:file_not_found]
        Process.exit
      end
    end
  end

  def choose_word()
    if @dictionary.empty?
      puts OUTPUT_MSGS[no_dict]
      Process.exit
    end
    words = @dictionary.values
    @secret_word = words[rand(words.size)]
  end

  def save_game(filename)
    #SAVES THE CURRENT GAME STATE
  end

  def load_game(filename)
    #LOADS THE SAVED GAME STATE
  end
end

#MAIN
if __FILE__ == $0
  game = Hangman.new("5desk.txt")

end
