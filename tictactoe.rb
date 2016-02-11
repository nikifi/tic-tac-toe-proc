
# require 'pry'

PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"

play_value = { 1 => " ", 2 => " ", 3 => " ", 4 => " ", 5 => " ", 6 => " ", 7 => " ", 8 => " ", 9 => " " }
winning_lines = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

def prompt(text)
  puts "=> #{text}"
end

def show_board(brd)
  puts "        |        |         "
  puts "   #{brd[1]}    |   #{brd[2]}    |   #{brd[3]}      "
  puts "________|________|________ "
  puts "        |        |         "
  puts "   #{brd[4]}    |   #{brd[5]}    |   #{brd[6]}     "
  puts "________|________|________ "
  puts "        |        |         "
  puts "   #{brd[7]}    |   #{brd[8]}    |   #{brd[9]}     "
  puts "        |        |         "
end

def initialize_board(brd)
  brd.each do |key, value|
    brd[key] = " "
  end
end

def valid_input?(input)
  if !input.to_i.between?(1, 9)
    puts "Please enter a valid and empty position"
    return false
  else return true
  end
end

def player_turn(brd)
  prompt("Please enter a valid integer value")
  while position = gets.chomp
    if valid_input?(position) == true
      if brd[position.to_i] != " "
        puts "Please enter an empty position"
      else
        brd[position.to_i] = PLAYER_MARKER
        break
      end
    end
  end
end

def check_empty(brd)
  empty_values = Array.new
  brd.each do |key, value|
    if value == " "
      empty_values.push(key)
    end
  end
end

# puts check_empty_hash(play_value)

def computer_turn(winning_lines, brd)
  winning_play = computer_play_strat(brd, find_winning_square(winning_lines, brd))
  defensive_play = computer_play_strat(brd, find_at_risk_square(winning_lines, brd))

  if winning_play.length >= 1
    brd_key = winning_play.sample
  elsif defensive_play.length >= 1
    brd_key = defensive_play.sample
  elsif brd[5] == " "
    brd_key = 5
  else brd_key = check_empty(brd).sample
  end

  sleep(1)

  brd[brd_key] = COMPUTER_MARKER
end

# find square where human player will likely win
def find_at_risk_square(winning_lines, brd)
  empty = Array.new
  winning_lines.each do |line|
    counter = 0
    line.each do |position|
      if brd[position] == PLAYER_MARKER
        counter += 1
      end
    end
    if counter == 2
      empty.push(line)
    end
  end
  empty.flatten
end

# find square where computer will win

def find_winning_square(winning_lines, brd)
  empty = Array.new
  winning_lines.each do |line|
    counter = 0
    line.each do |position|
      if brd[position] == COMPUTER_MARKER
        counter += 1
      end
    end
    if counter == 2
      empty.push(line)
    end
  end
  empty.flatten
end

# find empty location so that computer can defend or win
def computer_play_strat(brd, check_play)
  computer_play = Array.new
  check_play.each do |arr_key|
    if brd[arr_key] == " "
      computer_play.push(arr_key)
    end
  end
  computer_play.uniq
end

# checks if there is a winner
def check_winner(brd, winning_lines)
  winning_lines.each do |line|
   if brd[line[0]] == PLAYER_MARKER &&
      brd[line[1]] == PLAYER_MARKER &&
      brd[line[2]] == PLAYER_MARKER
    return 'Player'
   elsif brd[line[0]] == COMPUTER_MARKER &&
     brd[line[1]] == COMPUTER_MARKER &&
     brd[line[2]] == COMPUTER_MARKER 
     return 'Computer'    
    end
 end
  nil
end

def score_greater_than_5?(arr, player)
  if arr.count(player) == 5
    return true
  end
  return false
end

def show_winner(brd, winning_lines)

end

# main game 

loop do
  winner = Array.new
  loop do
    while check_empty(play_value).length > 0 && check_winner(play_value, winning_lines) == nil
      show_board(play_value)
      player_turn(play_value)
      computer_turn(winning_lines, play_value)
      puts "    "
    end
  show_board(play_value)

    # inserts current game score in array
    if check_winner(play_value, winning_lines) != nil?
      winner.push(check_winner(play_value, winning_lines))
    end
    if check_winner(play_value, winning_lines) == nil?
      prompt("Its a tie")
      initialize_board(play_value)
    elsif score_greater_than_5?(winner, check_winner(play_value, winning_lines)) == false
      prompt(" #{check_winner(play_value, winning_lines)} won this instance!")
      initialize_board(play_value)
    elsif score_greater_than_5?(winner, check_winner(play_value, winning_lines)) == true
      prompt(" #{check_winner(play_value, winning_lines)} won the game!")
    else prompt("something went wrong")
    end
      break if score_greater_than_5?(winner, check_winner(play_value, winning_lines))
    end
  initialize_board(play_value)
  prompt("Do you want to play again? y or n")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
