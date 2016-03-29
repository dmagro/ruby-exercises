require "tic-tac-toe.rb"

describe "Player object" do
  before :all do
      @player1 = Player.new("Bob", "X")
      @player2 = Player.new("Alice", "O")
  end

  it "has correct name for Bob" do
    expect(@player1.name).to eq("Bob")
  end

  it "has correct mark for Bob" do
    expect(@player1.mark).to eq("X")
  end

  it "has correct name for Alice" do
    expect(@player2.name).to eq("Alice")
  end

  it "has correct mark for Alice" do
    expect(@player2.mark).to eq("O")
  end
end

describe "Board object" do
  context "regular actions" do
    before :each do
      @game_board = Board.new 
    end

    it "starts empty mark" do
      empty_board = Array.new(Board::HEIGHT) { Array.new(Board::WIDTH) { Board::EMPTY_CELL_MARK }}
      expect(@game_board.board).to eq(empty_board)
    end

    it "makes a valid play" do
      expect(@game_board.make_play("X", 1)).to be_truthy
    end

    it "does not make a play in occupied position" do
      @game_board.make_play("O", 1)
      expect(@game_board.make_play("X", 1)).to be_falsey
    end
  end

  context "when could be a draw or win" do
    before :each do
      @game_board = Board.new 
      @game_board.make_play("X",2)
      @game_board.make_play("X",4)
      @game_board.make_play("X",5)
      @game_board.make_play("X",9)
      @game_board.make_play("O",1)
      @game_board.make_play("O",3)
      @game_board.make_play("O",8)
    end

    it "correctly verifies X win" do
      @game_board.make_play("X",6)
      expect(@game_board.verify_win("X")).to be_truthy
    end

    it "verifies that X does not win" do
      expect(@game_board.verify_win("X")).to be_falsey
    end

    it "correctly verifies draw" do
      @game_board.make_play("X",7)
      @game_board.make_play("O",6)
      expect(@game_board.verify_draw("O", "X")).to be_truthy
    end

    it "verifies that there is no draw" do
      expect(@game_board.verify_draw("O", "X")).to be_falsey
    end
  end
end