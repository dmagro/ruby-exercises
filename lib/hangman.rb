class Hangman

  MIN_LEN = 5
  MAX_LEN = 12
  OUTPUT_MSGS = { 
    ask_for_file: "There is no such file. Do you know where is the dictionary?",
    file_not_found: "Nope, file also not found. Exiting...",
    lose_msg: ", sorry mate..."
  }

  attr_reader :dictionary, :secret_word
  attr_accessor :dictionary_path

  def initialize(dictionary_path)
    @dictionary_path = dictionary_path
    @dictionary = load_dictionary()
    @secret_word = choose_word()
  end
  
  public

  private
  def ask_for_file()
    puts OUTPUT_MSGS[:ask_for_file]
    file_path = gets.chomp.tr(" \t\n", '')
  end

  def load_dictionary()
    begin
      filename = File.open(@dictionary_path, "r")
      filename.readlines.inject({}) {|hash,l| hash[l.chomp.to_sym]=l.chomp if l.chomp.length.between?(MIN_LEN, MAX_LEN); hash}
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
    
  end
end

#MAIN
if __FILE__ == $0
  game = Hangman.new("5desk.txt")
end
