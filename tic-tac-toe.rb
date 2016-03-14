
#Win condition based on the Magic Square method described here:
#http://mathworld.wolfram.com/MagicSquare.html
QUIT_COMMAND = 'quit'
QUIT_MSG = 'Bye bye...'

#Game Classes
class Player
  attr_reader :name, :mark
  def initialize(name, mark)
    @name = name
    @mark = mark
  end
end

class Board
  WIDTH = 3
  HEIGHT = 3
  N_SPACES = 4
  MAGIC_NUMBER = 15
  MAGIC_VALUES = [[8,1,6],[3,5,7],[4,9,2]] #Magic Square values for 3x3
  EXAMPLE_VALUES = [['1','2','3'],['4','5','6'],['7','8','9']]
  EMPTY_CELL_MARK = ''

  def initialize
    @board = reset_board
  end

  private
  def reset_board
    @board = Array.new(HEIGHT) { Array.new(WIDTH) { EMPTY_CELL_MARK }}
  end

  def translate_position(pos)
    [(pos-1)/WIDTH,(pos-1)%HEIGHT]
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

  def player_wins?(values, limit = MAGIC_NUMBER)
    values.sort!
    values.each_index do |i|
      asc_ptr = i+1
      desc_ptr = values.length-1
      while asc_ptr < desc_ptr
        tmp = values[asc_ptr] + values[desc_ptr] + values[i]
        if tmp > limit
          desc_ptr-=1
        elsif tmp < limit
          asc_ptr+=1
        else
          return true
        end
       end 
    end
    return false
  end

  def draw_divisor
    ((((N_SPACES*2)+2)*3)-1).times do
      print '-'
    end
    puts
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
    return false unless player_values.length >= 3 #needs at least three plays
    player_wins?(player_values)
  end

  def verify_draw(curr_player_mark, other_player_mark)
    (not @board.flatten.include? EMPTY_CELL_MARK) && (not verify_win(curr_player_mark)) && (not verify_win(other_player_mark))
  end

  def draw_board(example=false)
    values = @board
    values = EXAMPLE_VALUES unless not example

    values.each_with_index do |row, i|
      draw_divisor unless i==0
      row.each_with_index do |element, j|
        element = ' ' if element == ''

        if j != row.length-1
          printf "%#{N_SPACES+1}s %#{N_SPACES}s", element, '|'
        else
          printf "%#{N_SPACES+1}s\n", element
        end
      end
    end
    puts
  end
end

class TicTacToe
  PLAYER1 = :player1
  PLAYER2 = :player2
  MIN_VALID_POS = 1
  MAX_VALID_POS = 9
  OUTPUT_MSGS = { 
    player1_mark_request: "Insert Player 1 mark",
    player2_mark_request: "Insert Player 2 mark",
    mark_validation1: "\n Choose just one characters and different characters for each player...",
    mark_validation2: "Or, you know, just quit...\n",
    init_play_greet: "\nLet\'s play!!!",
    how_to_play_tip: "Tip: When you make a play choose the board position by picking one number as presented in:",
    player_turn: " turn:",
    invalid_position: "As to be a valid number (1-9)...",
    win_msg: " Wins!!!",
    lose_msg: ", sorry mate...",
    draw_msg: "Dudes... you both suck..."
  }

  attr_reader :board, :players, :current_player, :other_player

  def initialize()
    @board = Board.new
    @players = Hash.new
  end

  public
  def setup_game()
    player1_mark, player2_mark = get_players_settings()
    create_player("Player1", player1_mark)
    create_player("Player2", player2_mark)
    choose_who_starts()
  end

  def play_game()
    start_greetings()
    while true
      valid_play = false
      begin
        position = get_position()
        puts
        if not valid_position?(position)
          puts OUTPUT_MSGS[invalid_position]
          next
        end
        valid_play = @board.make_play(@current_player.mark, position.to_i)
      end until valid_play

      @board.draw_board()
      verify_win()
      verify_draw()
      @current_player, @other_player = @other_player, @current_player
    end
  end

  private
  #Private Auxiliar Methods...
  def validate_marks(mark1, mark2)
    ((not mark1.empty?) && (not mark2.empty?)) || (mark1.downcase == QUIT_COMMAND && mark2.downcase == QUIT_COMMAND)
  end

  def valid_position?(position)
    (position.to_i.to_s == position) && position.to_i.between?(MIN_VALID_POS, MAX_VALID_POS)
  end

  def check_exit(command)
    if command.downcase == QUIT_COMMAND
      puts QUIT_MSG
      Process.exit
    end
  end

  def get_mark(is_player1=false)
    msg = is_player1 ? :player1_mark_request : :player2_mark_request
    puts OUTPUT_MSGS[msg]
    player_mark = gets.chomp.tr(" \t\n", '')
    check_exit(player_mark)
    player_mark
  end

  #Private Game actions
  def get_players_settings()
    begin
      player1_mark = get_mark(true)
      player2_mark = get_mark()
      valid_marks = validate_marks(player1_mark, player2_mark)

      if not valid_marks
        puts OUTPUT_MSGS[mark_validation1]
        puts OUTPUT_MSGS[mark_validation2]
      end
    end until valid_marks
    [player1_mark, player2_mark]
  end

  def create_player(name, mark)
    player = Player.new(name, mark)
    key = players.empty? ? PLAYER1 : PLAYER2
    players[key] = player
  end

  def choose_who_starts()
    random_picked_player = @players.keys.sample 
    @current_player = @players[random_picked_player]
    @other_player = random_picked_player == PLAYER1 ? @players[PLAYER2] : @players[PLAYER1]
  end

  def start_greetings()
    puts OUTPUT_MSGS[:init_play_greet]
    puts OUTPUT_MSGS[:how_to_play_tip]
    @board.draw_board(true)
  end

  def get_position()
    puts @current_player.name + OUTPUT_MSGS[:player_turn]
    position = gets.chomp.tr(" \t\n", '')
  end

  def verify_win()
    if @board.verify_win(@current_player.mark)
      puts @current_player.name + OUTPUT_MSGS[:win_msg]
      puts @other_player.name + OUTPUT_MSGS[:lose_msg]
      check_exit(QUIT_COMMAND)
    end
  end

  def verify_draw
    if @board.verify_draw(@current_player.mark, @other_player.mark)
      puts OUTPUT_MSGS[:draw_msg]
      check_exit(QUIT_COMMAND)
    end
  end
end

#MAIN
if __FILE__ == $0
  game = TicTacToe.new
  game.setup_game()
  game.play_game()
end