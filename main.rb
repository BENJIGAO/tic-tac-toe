require 'pry-byebug'

module Validation
  def valid_move?(move)
    move.between?(1, 9) && !board.flatten[move - 1]
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
    update_board(move, player)
  end

  def update_board(move, player)
    case move
    when 1..3 then 
      board[0][move - 1] = player.symbol
      p board
    when 4..6 then board[1][move - 4] = player.symbol
    when 7..9 then board[2][move - 7] = player.symbol
    end
  end

  def game_over?
    false
  end
end

class Player 
  attr_reader :symbol

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
      puts "switching to next player..."
      tic_tac_toe.play_turn(player2)
      break if tic_tac_toe.game_over?
    end
  end
end

tic_tac_toe

# tmp_game = TicTacToe.new("Bob", "George")
# tmp_game.board[0][1] = "test"
# p tmp_game.board
