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
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
    @game_over = false
  end

  def self.introduction
    puts "Welcome to Tic Tac Toe!"
    sleep 1
  end

  def play_turn(player)
    move = nil
    loop do
      print_board
      move = player.choose_move
      unless valid_move?(move)
        puts 'Invalid entry. Please try again'
        sleep 2
        next
      end
      break
    end
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
      print_board
      puts "\nCongratulations #{player.name}, you are the tic-tac-toe master!"
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
    row = row.each_with_index.map { |symbol, index| !symbol ? (row_num) * 3 + index + 1 : symbol }
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
    board.each_with_index { |row, row_num| print_row(row, row_num) }
    puts ""
  end
end

# Represents a player playing tic-tac-toe
class Player
  attr_reader :symbol, :name

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def choose_move
    puts "Hey #{name}!"
    print 'Select your play by entering a number 1-9: '
    gets.chomp.to_i
  end

  def self.create_player(player)
    name = nil
    loop do 
      print "Enter #{player}'s name. (only letters/numbers/spaces/apostrophes accepted): "
      name = gets.chomp
      break unless /^(?![a-z0-9' ]*$)/i.match(name)
    end

    symbol = nil
    loop do
      print "Enter #{player}'s symbol (one character): "
      symbol = gets.chomp
      break if symbol.length == 1
    end
    puts ""
    Player.new(name, symbol)
  end
end

def tic_tac_toe()
  loop do
    TicTacToe.introduction
    player1 = Player.create_player("player 1")
    player2 = Player.create_player("player 2")
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
