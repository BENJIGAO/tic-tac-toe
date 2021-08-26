module Validation
  def valid_move?(move)
    move.between?(1, 9) && !board.flatten[move]
  end
end


class TicTacToe
  include Validation

  attr_accessor :board
  attr_reader :game_over

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil],
    ]
    @game_over = false
  end

  def play_turn(player)
    move = player.choose_move(board)
    until valid_move?(move)
      move = player.choose_move(board)
    end
    update_board(move)
  end

  def update_board(move)
    
  end
end

class Player 
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def choose_move(board)
    p board
    puts "Choose your play: "
    gets.chomp.to_i
  end
end

def tic_tac_toe()
  loop do
    player1 = Player.new("George", "X")
    player2 = Player.new("Bob", "O")
    tic_tac_toe = TicTacToe.new(player1, player2)
    until tic_tac_toe.game_over
      tic_tac_toe.play_turn(player1)
      break if tic_tac_toe.game_over?
      tic_tac_toe.play_turn(player2)
      break if tic_tac_toe.game_over?
    end
  end
end

tic_tac_toe

  

