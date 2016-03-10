
#Win condition based on the Magic Square method described here:
#http://mathworld.wolfram.com/MagicSquare.html
QUIT_COMMAND = 'quit'

class Player
  attr_reader :mark
  def initialize(mark)
    @mark = mark
  end
end

class Board
  BOAR_VALUES = [[8,1,6],[3,5,7],[4,9,2]] #Magic Square values for 3x3

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = [['','',''], ['','',''], ['','','']]
  end
end

def valid_marks?(mark1, mark2)
  ((not mark1.empty?) && (not mark2.empty?)) || (mark1.downcase == QUIT_COMMAND && mark2.downcase == QUIT_COMMAND)
end

def check_exit(command)
  if command.downcase == QUIT_COMMAND
    puts 'Bye bye...'
    Process.exit
  end
end

if __FILE__ == $0
    
  begin
    puts 'Insert Player 1 mark'
    player1_mark = gets.chomp.tr(" \t\n", '')
    check_exit(player1_mark)

    puts 'Insert Player 2 mark'
    player2_mark = gets.chomp.tr(" \t\n", '')
    check_exit(player2_mark)

    valid_marks = valid_marks?(player1_mark, player2_mark)

    if not valid_marks
      puts
      puts 'Choose just one characters and different characters for each player...'
      puts 'Or, you know, just quit...'
      puts
    end
 
  end until valid_marks

  puts
  puts 'Let\'s play!!!'

  player1 = Player.new(player1_mark)
  player2 = Player.new(player2_mark)
  board = Board.new(player1_mark, player2_mark)
  
end