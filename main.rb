require 'pry-byebug'

# Specific to tic-tac-toe. Validates user input
module Validation
  def valid_move?(move)
    move.between?(1, 9) && !board.flatten[move - 1]
  end
end

# Represents a two-player game of tic-tac-toe. Has all functionality for terminal-based game. 
class TicTacToe
  include Validation

  attr_accessor :board
  attr_reader :game_over

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = [
      ['X', 'X', nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
    @game_over = false
  end

  def play_turn(player)
    print_board
    move = player.choose_move(board)
    move = player.choose_move(board) until valid_move?(move)
    update_board(move, player)
  end

  def update_board(move, player)
    case move
    when 1..3 then board[0][move - 1] = player.symbol
    when 4..6 then board[1][move - 4] = player.symbol
    when 7..9 then board[2][move - 7] = player.symbol
    end
  end

  def winner?(player)
    win_combinations = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
    players_board = []
    board.flatten.each_with_index { |square, index| players_board.push(index + 1) if square == player.symbol }
    return if players_board.length < 3

    if win_combinations.any? { |combo| (players_board - combo).length == players_board.length - 3 }
      puts "Congratulations #{player.name}, you are the tic-tac-toe master!"
      return true
    end
    false
  end

  def exit?
    sleep 1
    response = nil
    loop do
      puts 'Do you wish to exit? [Y/n]'
      response = gets.chomp
      break if /\A[Yn]\Z/.match(response)
    end
    response == 'Y'
  end

  def print_row(row, row_num)
    row = row.each_with_index.map { |symbol, index| !symbol ? (row_num - 1) * 3 + index + 1 : symbol }
    1.upto(3) do |row_level|
      if row_level == 2
        terminal_output = row.reduce('') do |output, symbol|
          output + "   #{symbol}   |"
        end
        puts terminal_output[0..-2]
      else
        puts '       |' * 2
      end
    end
    puts '-' * 23 unless row_num == 2
  end

  def print_board
    board.each_with_index { |row, row_num| print_row(row, row_num)}
  end
end

# Represents a player playing tic-tac-toe
class Player
  attr_reader :symbol, :name

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def choose_move(board)
    p board
    puts 'Choose your play: '
    gets.chomp.to_i
  end
end

def tic_tac_toe()
  loop do
    player1 = Player.new('George', 'X')
    player2 = Player.new('Bob', 'O')
    tic_tac_toe = TicTacToe.new(player1, player2)
    until tic_tac_toe.game_over
      tic_tac_toe.play_turn(player1)
      break if tic_tac_toe.winner?(player1)

      tic_tac_toe.play_turn(player2)
      break if tic_tac_toe.winner?(player2)
    end
    break if tic_tac_toe.exit?
  end
end

tic_tac_toe
