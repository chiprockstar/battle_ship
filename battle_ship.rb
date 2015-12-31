class Array2Dimensions

  def initialize
    @store = [[]]
  end

  def [] (a,b)              #-- multideminsional arrays
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
    @computer = Array2Dimensions.new
    @computer_selects = Array.new
    @player_selects = Array.new
  end

  def init_data_struct
    #-- initialize board locations to 1 space
    0.upto(4).each do | x |
      0.upto(4).each do | y |
        @a[x, y] = ' '
        @b[x, y] = ' '
        @computer[x, y] = ' '
      end
    end
  end


  def place_cruisers
    ['@a', '@b'].each do | str |
      #-- cruiser positions
      eval("#{str}")[rand(5), rand(5)] = 'c'
    end
  end


  def place_destroyers
    ['@a', '@b'].each do | str |
      #-- destroyer positions
      destroyer_placed = false
      while destroyer_placed == false
        if rand(2) == 0 #-- row or column
          row = rand(5); col = rand(4)
          col.upto(col+1).each do | y |
            if eval("#{str}")[row, y] != ' '
              destroyer_placed = false
              break
            else
              destroyer_placed = true
            end
          end
          if destroyer_placed
            col.upto(col+1).each do | y |
              eval("#{str}")[row, y] = 'd'
            end
          end
        else #-- column
          row = rand(4); col = rand(5)
          row.upto(row+1).each do | x |
            if eval("#{str}")[x, col] != ' '
              destroyer_placed = false
              break
            else
              destroyer_placed = true
            end
          end
          if destroyer_placed
            row.upto(row+1).each do | x |
              eval("#{str}")[x, col] = 'd'
            end
          end
        end
      end
    end
  end

  def place_battleships
    ['@a', '@b'].each do | str |
      #-- battleship positions
      battleship_placed = false
      while battleship_placed == false
        if rand(2) == 0 #-- row or column
          row = rand(5); col = rand(3)
          col.upto(col+2).each do | y |
            if eval("#{str}")[row, y] != ' '
              battleship_placed = false
              break
            else
              battleship_placed = true
            end
          end
          if battleship_placed
            col.upto(col+2).each do | y |
              eval("#{str}")[row, y] = 'b'
            end
          end
        else #-- column
          row = rand(3); col = rand(5)
          row.upto(row+2).each do | x |
            if eval("#{str}")[x, col] != ' '
              battleship_placed = false
              break
            else
              battleship_placed = true
            end
          end
          if battleship_placed
            row.upto(row+2).each do | x |
              eval("#{str}")[x, col] = 'b'
            end
          end
        end
      end
    end
  end



  def draw_boards
    system "clear"
    ['@a', '@b'].each do  | str |
      puts ""
      if str == '@a'
        puts "Willy's Board"
      else
        puts "Computer's Board"
      end
      puts "    1   2   3   4   5"
      col = 0
      0.upto(4).each do |row|
        puts "  +---+---+---+---+---+"
        puts "#{row+1} | #{eval(str)[row,col]} | #{eval(str)[row,col+1]} | #{eval(str)[row,col+2]} | #{eval(str)[row,col+3]} | #{eval(str)[row,col+4]} |"
      end
      puts "  +---+---+---+---+---+"
      puts ""
      turn = '@computer_selects' if str == '@a'
      turn = '@player_selects'   if str == '@b'

      #-- set ship statuses
      destroyer_status =  'Alive'
      cruiser_status =    'Alive'
      battleship_status = 'Alive'
      destroyer_status =   'Dead' if eval(turn).grep('d').size == 2
      battleship_status = ' Dead' if eval(turn).grep('b').size == 3
      cruiser_status =     'Dead' if eval(turn).grep('c').size == 1

      puts "Destroyer: #{destroyer_status}  Cruiser: #{cruiser_status}  Battleship: #{battleship_status}"

    end
  end

  def evaluate_game
    #-- evaluate game
    if @player_selects.grep('b').size == 3 && @player_selects.grep('c').size == 1 && @player_selects.grep('d').size == 2
      puts "Game Over - Willy Wins!"
      exit
    elsif @computer_selects.grep('b').size == 3 && @computer_selects.grep('c').size == 1 && @computer_selects.grep('d').size == 2
      puts "Game Over - Computer Wins!"
      exit
    end
  end

  def player_turn
    #-- player takes turn
    puts "Select a square such as (3,5) to open fire. Enter q to quit."
    coord = gets.chomp
    exit if coord == 'q'
    split_value = coord.split(",").map { |x| x.to_i }
    @player_selects << "#{@b[split_value.last - 1, split_value.first - 1]}"

    if @b[split_value.last - 1, split_value.first - 1] == ' '
      @b[split_value.last - 1, split_value.first - 1] = '/'
    else
      @b[split_value.last - 1, split_value.first - 1] = 'x'
    end
  end

  def computer_turn
    #-- computer takes turn
    process = true
    while process
      row = rand(5); col = rand(5)
      if !@computer[row, col].include?("x") && !@computer[row, col].include?("/")
        @computer_selects << "#{@a[row, col]}"
        if @a[row, col] == ' '
          @a[row, col]  = '/'
        elsif @a[row, col].scan(/\w/)
          @a[row, col] = 'x'
        end
        @computer[row, col] = "#{@a[row, col]}"
        process = false
      end
    end
  end
end

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
