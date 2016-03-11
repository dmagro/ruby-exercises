
#Win condition based on the Magic Square method described here:
#http://mathworld.wolfram.com/MagicSquare.html
QUIT_COMMAND = 'quit'

#Game Classes
class Player
  attr_reader :mark
  def initialize(mark)
    @mark = mark
  end
end

class Board
  MAGIC_NUMBER = 15
  MAGIC_VALUES = [[8,1,6],[3,5,7],[4,9,2]] #Magic Square values for 3x3
  EMPTY_CELL_MARK = ''

  def initialize
    @board = reset_board
  end

  private
  def reset_board
    @board = Array.new(3) { Array.new(3) { EMPTY_CELL_MARK }
  end

  def translate_position(pos)
    [(pos-1)%3,(pos-1)/3]
  end

  def cell_empty?(x, y)
    @board[x][y] == EMPTY_CELL_MARK
  end

  def get_magic_values(player_mark)
    values = []

    @board.each_index do |x|
      @board[x].each_index do |y|
        values << MAGIC_VALUES[x][y] unless @board[x][y] != player_mark
      end
    end

    values
  end

  def player_wins?(values, limit = MAGIC_NUMBER, idx=0)
     if idx >= values.length
        if limit == 0
            return true
        else
            return false
        end
    end

    if !player_wins?(values, limit, idx + 1)
        player_wins?(values, limit - values[idx], idx + 1)
    else
        return true
    end
  end

  public
  def make_play(player_mark, pos)
    x,y = translate_position(pos)
    valid_play = cell_empty?(x,y)

    if valid_play
      @board[x][y] = player_mark
    end

    valid_play
  end

  def verify_win(player_mark)
    player_values = get_magic_values(player_mark)
    return false unless player_values.lenght >= 3 #needs at least three plays
    player_wins?(player_values)
  end

  def verify_draw
    @board.flatten.map { |cell| cell} != EMPTY_CELL_MARK
  end
end

#Auxiliar Methods...
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
  board = Board.new
  
end