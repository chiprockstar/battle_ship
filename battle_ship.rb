require 'colorize'

class Array2Dimensions

  def initialize
    @store = [[]]
  end

  def [] (a,b)              #-- multidimensional arrays
    if @store[a] == nil ||
      @store[a][b] == nil
      return nil
    else
      return @store [a][b]
    end
  end

  def []=(a,b,x)
    @store[a] = [] if @store[a] == nil
    @store[a][b] = x
  end
end


class Battleship

  def initialize
    #-- initialize arrays
    @a = Array2Dimensions.new
    @b = Array2Dimensions.new
    @computer_shots = Array.new
    @player_shots = Array.new
  end

  def init_data_struct
    #-- initialize board locations to 1 space
    0.upto(4).each do | x |
      0.upto(4).each do | y |
        @a[x, y] = ' '
        @b[x, y] = ' '
      end
    end
  end

  def place_cruisers
    ['@a', '@b'].each do | str |
      #-- randomize cruiser positions
      eval(str)[rand(5), rand(5)] = 'c'
    end
  end

  def place_destroyers
    ['@a', '@b'].each do | str |
      #-- randomize destroyer positions
      destroyer_placed = false
      while destroyer_placed == false
        if rand(2) == 0 #-- row or column
          row = rand(5); col = rand(4)
          col.upto(col+1).each do | y |
            if eval(str)[row, y] != ' '
              destroyer_placed = false #-- check for row collisions
              break
            else
              destroyer_placed = true
            end
          end
          if destroyer_placed
            col.upto(col+1).each do | y | #-- place destroyer in a row
              eval(str)[row, y] = 'd'
            end
          end
        else #-- column
          row = rand(4); col = rand(5)
          row.upto(row+1).each do | x |
            if eval(str)[x, col] != ' '
              destroyer_placed = false #-- check for column collisions
              break
            else
              destroyer_placed = true
            end
          end
          if destroyer_placed
            row.upto(row+1).each do | x | #-- place destroyer in a column
              eval(str)[x, col] = 'd'
            end
          end
        end
      end
    end
  end

  def place_battleships
    ['@a', '@b'].each do | str |
      #-- randomize battleship positions
      battleship_placed = false
      while battleship_placed == false
        if rand(2) == 0 #-- row or column
          row = rand(5); col = rand(3)
          col.upto(col+2).each do | y |
            if eval(str)[row, y] != ' '
              battleship_placed = false #-- check for row collisions
              break
            else
              battleship_placed = true
            end
          end
          if battleship_placed
            col.upto(col+2).each do | y | #-- place battleship in row
              eval(str)[row, y] = 'b'
            end
          end
        else #-- place in a column
          row = rand(3); col = rand(5)
          row.upto(row+2).each do | x |
            if eval(str)[x, col] != ' '
              battleship_placed = false #-- check for column collisions
              break
            else
              battleship_placed = true
            end
          end
          if battleship_placed
            row.upto(row+2).each do | x | #-- place battleship in column
              eval(str)[x, col] = 'b'
            end
          end
        end
      end
    end
  end

  def colorize(position)
    color = :white
    color = :magenta if position == 'c'
    color = :yellow  if position == 'd'
    color = :green   if position == 'b'
    color = :blue    if position == '/'
    color = :red     if position == 'x'
    " #{position.colorize(color)}"
  end

  def print_game_status(str)
    turn = '@computer_shots' if str == '@a'
    turn = '@player_shots'   if str == '@b'
    #-- set ship statuses
    destroyer_status =  'Alive'.colorize(:green)
    cruiser_status =    'Alive'.colorize(:green)
    battleship_status = 'Alive'.colorize(:green)
    destroyer_status =   'Dead'.colorize(:red) if eval(turn).grep('d').size == 2
    battleship_status =  'Dead'.colorize(:red) if eval(turn).grep('b').size == 3
    cruiser_status =     'Dead'.colorize(:red) if eval(turn).grep('c').size == 1
    puts "Destroyer: #{destroyer_status}  Cruiser: #{cruiser_status}  Battleship: #{battleship_status}\n"
  end

  def draw_boards
    system "clear"
    ['@a', '@b'].each do  | str |

      if str == '@a'
        puts "Willy's Board"
      else
        puts "Computer's Board"
      end

      puts "    1   2   3   4   5"

      0.upto(4).each do |row|
        print "  +---+---+---+---+---+\n"
        print "#{row+1} |"
        print "#{colorize(eval(str)[row,0])} |"
        print "#{colorize(eval(str)[row,1])} |"
        print "#{colorize(eval(str)[row,2])} |"
        print "#{colorize(eval(str)[row,3])} |"
        print "#{colorize(eval(str)[row,4])} |\n"
      end

      puts    "  +---+---+---+---+---+"
      puts    ""
      print_game_status(str)
    end
  end

  def game_over?(player)
    if eval(player).grep('b').size == 3 &&
       eval(player).grep('c').size == 1 &&
       eval(player).grep('d').size == 2
       return true
    else
       return false
     end
  end

  def evaluate_game
    #-- evaluate game
    ['@player_shots', '@computer_shots'].each do | player |
      if game_over?(player)
        puts ""
        puts "Game Over - Willy Wins!".colorize(:green)    if player == '@player_shots'
        puts "Game Over - Computer Wins!".colorize(:green) if player == '@computer_shots'
        exit
      end
    end
  end

  def player_turn
    #-- player takes turn
    puts "Select a square such as (3,5) to open fire. Enter q to quit."
    coord = gets.chomp
    exit if coord == 'q'
    split_param = coord.split(",").map { |x| x.to_i }
    row = split_param.last - 1
    col = split_param.first - 1
    position = lambda { @b[row, col] }

    set_position = lambda { |char| @b[row, col] = char }
    @player_shots << position.call
    if position.call == ' '
      set_position.call('/')
    else
      set_position.call('x')
    end
  end

  def computer_turn
    #-- computer takes turn
    process = true
    while process
      row = rand(5); col = rand(5)
      position = lambda { @a[row, col] }
      if !position.call.include?("x") && !position.call.include?("/")
        set_position = lambda { |char| @a[row, col] = char }

        @computer_shots << position.call
        if position.call == ' '
          set_position.call('/')
        elsif position.call.scan(/\w/)
          set_position.call('x')
        end
        process = false
      end
    end
  end
end

#-- fire it up
c = Battleship.new
c.init_data_struct
c.place_cruisers
c.place_destroyers
c.place_battleships
c.draw_boards
while 1 == 1
  c.player_turn
  c.draw_boards
  c.evaluate_game
  c.computer_turn
  c.draw_boards
  c.evaluate_game
end
