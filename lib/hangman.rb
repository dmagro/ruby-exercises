require 'yaml'

OUTPUT_MSGS = { 
    ask_for_letter: "Give me a letter:",
    used_letter: "You've already played that...",
    file_not_found: "Nope, file also not found. Exiting...",
    dict_not_found: "Dictionary not found...",
    game_not_found: "Game file not found...", 
    no_dict: "No dictionary available. Exiting...",
    win_msg: "Wow you win! You know a word...",
    lose_msg: "You lose, sorry mate...",
    save_msg: "Game saved...",
    load_msg: "Game loaded...",
    ask_file_path: "Please insert file location...",
    quit_msg: "Bye bye...",
    bad_input: "I have no idea what to do with that.",
    ask_overwrite: "File already exists... Do you want to overwrite it?(Y/n)",
    overwrite_msg: "Overwriting file..."
  }

class Hangman
  FAILS_LIMIT = 6
  EMPTY_CHAR = "_"

  attr_reader :dictionary, :secret_word
  attr_accessor :guessed_letters, :played_letters

  def initialize(dictionary)
    @dictionary = dictionary
    game_reset()
  end
  
  public
  #SECRET WORD METHODS
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
    @guessed_letters = @secret_word.gsub(/[a-z]/, EMPTY_CHAR).scan(/./)
  end

  def insert_letter(letter, positions)
    positions.each do |idx|
      @guessed_letters[idx] = letter
    end
  end

  def insert_played_letter(letter)
    @played_letters << letter
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
    puts "\t #{@guessed_letters.join(" ")} \t Fails: #{@guess_fails.to_s}"
  end

  #GAME STATE METHODS
  def game_reset()
    choose_word()
    @guess_fails = 0
    reset_guessed_letters()
    @played_letters = []
  end

  def player_wins?()
    (not @guessed_letters.empty?) && (not @guessed_letters.include?(EMPTY_CHAR))  
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

  def self.deserialize(yaml_string)
    YAML::load(yaml_string)
  end
  
  def serialize
    YAML::dump(self)
  end
end

class Game
  MIN_LEN = 5
  MAX_LEN = 12
  AFFIRMATIVE_CHAR = "y"
  
  COMMANDS = {
    letter: "letter",
    save: "save",
    load: "load",
    quit: "quit"
  }

  attr_reader :hangman
  def initialize(dictionary_path)
    @hangman = Hangman.new(load_dictionary(dictionary_path))
  end

  private
  def ask_for_file()
    puts OUTPUT_MSGS[:ask_file_path]
    file_path = gets.chomp.tr(" \t\n", '')
  end

  def is_letter(letter)
    if letter.length == 1 && letter.between?('a','z')
      return letter
    else #hack to pass switch by...
      return false 
    end
  end

  def read_file(filename, is_dictionary_context=false)
    begin
      return File.open(filename, "r")
    rescue Errno::ENOENT
      puts is_dictionary_context ? OUTPUT_MSGS[:dict_not_found] : OUTPUT_MSGS[:game_not_found]
      file_path = ask_for_file()
      if File.exists? file_path
        filename = file_path
        retry
      else
        puts OUTPUT_MSGS[:file_not_found]
        Process.exit
      end
    end
  end

  def valid_word?(word)
    word.length.between?(MIN_LEN, MAX_LEN)
  end

  def load_dictionary(dictionary_path)
    dictionary = {}
    file = read_file(dictionary_path, true)
    file.readlines.inject(dictionary){ |hash,line| word = line.chomp.downcase; hash[word.to_sym] = word if valid_word?(word); hash}
    file.close
    dictionary
  end

  def overwrite?()
    overwriting=false
    puts OUTPUT_MSGS[:ask_overwrite]
    answer = gets.chomp.tr(" \t\n", '').downcase
    return overwriting if answer != AFFIRMATIVE_CHAR
    puts OUTPUT_MSGS[:overwrite_msg]
    overwriting = true
  end

  def save_game(filename)
    if File.exists? filename
      return false if not overwrite?
    end

    File.open(filename, "w") do |file|
      yaml_saved_game = @hangman.serialize()
      file.puts(yaml_saved_game)
    end
    puts OUTPUT_MSGS[:save_msg]
  end

  def load_game(filename)
    yaml_string = read_file(filename).read
    @hangman = Hangman.deserialize(yaml_string)
    puts OUTPUT_MSGS[:load_msg]
  end 

  public
  def play_game()
    while not @hangman.game_over?()
      @hangman.display_state()
      puts OUTPUT_MSGS[:ask_for_letter]
      command = gets.chomp.tr(" \t\n", '').downcase

      case command
      when is_letter(command)
        if @hangman.played_letters.include?(command)
          puts OUTPUT_MSGS[:used_letter]
          next
        else 
          @hangman.insert_played_letter(command)
          @hangman.validate_play(command)
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
end

#MAIN
if __FILE__ == $0
  game = Game.new("5desk.txt")
  game.play_game()
end
