class Hangman

  MIN_LEN = 5
  MAX_LEN = 12
  FAILS_LIMIT = 6
  EMPTY_CHAR = "_"
  OUTPUT_MSGS = { 
    ask_for_letter: "Give me a letter:",
    used_letter: "You've already played that...",
    ask_for_file: "There is no such file. Do you know where is the dictionary?",
    file_not_found: "Nope, file also not found. Exiting...",
    no_dict: "No dictionary available. Exiting...",
    win_msg: "Wow you win! You know a word...",
    lose_msg: "You lose, sorry mate...",
    save_msg: "Game saved...",
    load_msg: "Game loaded...",
    ask_file_path: "Please insert file location...",
    quit_msg: "Bye bye...",
    bad_input: "I have no idea what to do with that."
  }

  COMMANDS = {
    letter: "letter",
    save: "save",
    load: "load",
    quit: "quit"
  }

  attr_reader :dictionary, :secret_word, :letters_guessed, :played_letters
  attr_accessor :dictionary_path

  def initialize(dictionary_path)
    @dictionary_path = dictionary_path
    load_dictionary()
    game_reset()
  end
  
  public
  def play_game()
    while not game_over?()

      display_state()
      puts OUTPUT_MSGS[:ask_for_letter]
      command = gets.chomp.tr(" \t\n", '').downcase

      case command
      when is_letter(command)
        if @played_letters.include?(command)
          puts OUTPUT_MSGS[:used_letter]
          next
        else 
          @played_letters << command
          validate_play(command)
        end
      when COMMANDS[:save]
        filename = ask_for_file()
        save_game(filename)
      when COMMANDS[:load]
        filename = ask_for_file()
        load_game(filename)
      when COMMANDS[:quit]
        puts OUTPUT_MSGS[:quit_msg]
        Process.exit
      else
        puts OUTPUT_MSGS[:bad_input]
      end
    end
  end

  private
  #INPUT METHODS
  def ask_for_file(is_dict=false)
    puts is_dict ? OUTPUT_MSGS[:ask_for_file] : OUTPUT_MSGS[:ask_file_path]
    file_path = gets.chomp.tr(" \t\n", '')
  end

  def is_letter(letter)
    if letter.length == 1 && letter.between?('a','z')
      return letter
    else #hack to pass switch by...
      return false 
    end
  end

  #SECRET WORD METHODS
  def valid_word?(word)
    word.length.between?(MIN_LEN, MAX_LEN)
  end

  def load_dictionary()
    @dictionary = {}
    begin
      filename = File.open(@dictionary_path, "r")
      filename.readlines.inject(@dictionary){ |hash,line| word = line.chomp.downcase; hash[word.to_sym] = word if valid_word?(word); hash}
      filename.close
    rescue Errno::ENOENT
      file_path = ask_for_file(true)
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

  def get_letter_positions(letter)
    result = []
    @secret_word.scan(/./).each_with_index{|char, idx| result << idx if char==letter}
    result
  end

  def reset_guessed_letters()
    @letters_guessed = @secret_word.gsub(/[a-z]/, EMPTY_CHAR).scan(/./)
  end

  def insert_letter(letter, positions)
    positions.each do |idx|
      @letters_guessed[idx] = letter
    end
  end

  def validate_play(letter)
    indexes = get_letter_positions(letter)
    if indexes.empty?
      @guess_fails+=1
    else
      insert_letter(letter, indexes)
    end
  end

  def display_state
    puts ""
    puts "\t #{@letters_guessed.join(" ")} \t Fails: #{@guess_fails.to_s}"
  end

  #GAME STATE METHODS
  def game_reset()
    choose_word()
    @guess_fails = 0
    reset_guessed_letters()
    @played_letters = []
  end

  def player_wins?()
    (not @letters_guessed.empty?) && (not @letters_guessed.include?(EMPTY_CHAR))  
  end

  def player_loses?()
    @guess_fails == FAILS_LIMIT
  end

  def game_over?()
    if player_wins?
      puts OUTPUT_MSGS[:win_msg]
      return true
    elsif player_loses?
      puts OUTPUT_MSGS[:lose_msg]
      return true
    else
      return false
    end
  end

  def save_game(filename)
    #SAVES THE CURRENT GAME STATE
    puts OUTPUT_MSGS[:save_msg]
  end

  def load_game(filename)
    #LOADS THE SAVED GAME STATE
    puts OUTPUT_MSGS[:load_msg]
  end
end

#MAIN
if __FILE__ == $0
  game = Hangman.new("5desk.txt")
  game.play_game()
end
