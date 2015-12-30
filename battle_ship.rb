
class Array2
  #-- this class allows using arrays like a[row, col] to set and get
  def initialize
    @store = [[]]
  end

  def [] (a,b)
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

#-- initialize arrays
a = Array2.new
b = Array2.new
computer = Array2.new
computer_destroyer = Array2.new
computer_battle_ship = Array2.new
computer_selects = []
player_selects = []

#-- initialize data structure
0.upto(4).each do | x |
  0.upto(4).each do | y |
    a[x, y] = ' '
    b[x, y] = ' '
    computer[x, y] = ' '
  end
end

#-- place ships on both boards randomly
['a', 'b'].each do | letter |
    #-- cruiser positions
  eval("#{letter}")[rand(5), rand(5)] = 'c'

  #-- destroyer positions
  destroyer_placed = false
  while destroyer_placed == false
    if rand(2) == 0 #row
      row = rand(5)
      col = rand(4)
      col.upto(col+1).each do | y |
        if eval("#{letter}")[row, y] != ' '
          destroyer_placed = false
          break
        else
          destroyer_placed = true
        end
      end
      if destroyer_placed
        col.upto(col+1).each do | y |
          eval("#{letter}")[row, y] = 'd'
        end
      end
    else #column
      row = rand(4)
      col = rand(5)
      row.upto(row+1).each do | x |
        if eval("#{letter}")[x, col] != ' '
          destroyer_placed = false
          break
        else
          destroyer_placed = true
        end
      end
      if destroyer_placed
        row.upto(row+1).each do | x |
          eval("#{letter}")[x, col] = 'd'
        end
      end
    end
  end

#-- battleship positions
  battleship_placed = false
  while battleship_placed == false
    if rand(2) == 0 #row
      row = rand(5)
      col = rand(3)
      col.upto(col+2).each do | y |
        if eval("#{letter}")[row, y] != ' '
          battleship_placed = false
          break
        else
          battleship_placed = true
        end
      end
      if battleship_placed
        col.upto(col+2).each do | y |
          eval("#{letter}")[row, y] = 'b'
        end
      end

    else #column
      row = rand(3)
      col = rand(5)
      row.upto(row+2).each do | x |
        if eval("#{letter}")[x, col] != ' '
          battleship_placed = false
          break
        else
          battleship_placed = true
        end
      end
      if battleship_placed
        row.upto(row+2).each do | x |
          eval("#{letter}")[x, col] = 'b'
        end
      end
    end
  end
end


coord = ''
while coord != 'q'
  system "clear"

  ['a', 'b'].each do  | letter |
    puts ""
    if letter == 'a'
      puts "Willy's Board"
    else
      puts "Computer's Board"
    end
    puts "    1   2   3   4   5"
    puts "  +---+---+---+---+---+"
    puts "1 | #{eval(letter)[0,0]} | #{eval(letter)[0,1]} | #{eval(letter)[0,2]} | #{eval(letter)[0,3]} | #{eval(letter)[0,4]} |"
    puts "  +---+---+---+---+---+"
    puts "2 | #{eval(letter)[1,0]} | #{eval(letter)[1,1]} | #{eval(letter)[1,2]} | #{eval(letter)[1,3]} | #{eval(letter)[1,4]} |"
    puts "  +---+---+---+---+---+"
    puts "3 | #{eval(letter)[2,0]} | #{eval(letter)[2,1]} | #{eval(letter)[2,2]} | #{eval(letter)[2,3]} | #{eval(letter)[2,4]} |"
    puts "  +---+---+---+---+---+"
    puts "4 | #{eval(letter)[3,0]} | #{eval(letter)[3,1]} | #{eval(letter)[3,2]} | #{eval(letter)[3,3]} | #{eval(letter)[3,4]} |"
    puts "  +---+---+---+---+---+"
    puts "5 | #{eval(letter)[4,0]} | #{eval(letter)[4,1]} | #{eval(letter)[4,2]} | #{eval(letter)[4,3]} | #{eval(letter)[4,4]} |"
    puts "  +---+---+---+---+---+"
    puts ""
    turn = 'computer_selects' if letter == 'a'
    turn = 'player_selects' if letter == 'b'
    destroyer_status = 'Alive'
    cruiser_status = 'Alive'
    battleship_status = 'Alive'
    if eval(turn).grep('d').size == 2
      destroyer_status = 'Dead'
    end
    if eval(turn).grep('b').size == 3
      battleship_status = 'Dead'
    end
    if eval(turn).grep('c').size == 1
      cruiser_status = 'Dead'
    end
    puts "Destroyer: #{destroyer_status}  Cruiser: #{cruiser_status}  Battleship: #{battleship_status}"
  end

  #-- evaluate game
  if player_selects.grep('b').size == 3 && player_selects.grep('c').size == 1 && player_selects.grep('d').size == 2
    puts "Game Over - Willy Wins!"
    exit
  elsif computer_selects.grep('b').size == 3 && computer_selects.grep('c').size == 1 && computer_selects.grep('d').size == 2
    puts "Game Over - Computer Wins!"
    exit
  end

  #-- player takes turn
  puts "Select a square such as (3,5) to open fire. Enter q to quit."
  coord = gets.chomp
  split_value = coord.split(",").map { |x| x.to_i } if coord != 'q'
  player_selects << "#{b[split_value.last - 1, split_value.first - 1]}"

  if b[split_value.last - 1, split_value.first - 1] == ' ' && coord != 'q'
    b[split_value.last - 1, split_value.first - 1] = '/'
  else
    b[split_value.last - 1, split_value.first - 1] = 'x'
  end


  #-- computer takes turn
  process = true
  while process
    row = rand(5)
    col = rand(5)
    if !computer[row, col].include?("x") && !computer[row, col].include?("/")
      computer_selects << "#{a[row, col]}"
      if a[row, col] == ' '
        a[row, col]  = '/'
      elsif a[row, col].scan(/\w/)
        a[row, col] = 'x'
      end
      computer[row, col] = "#{a[row, col]}"
      process = false
    end
  end
end
