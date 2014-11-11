ROWS = 9
COLUMNS = 9
BOMBS = 2

class Minesweeper
  attr_accessor :board, :bomb_locs

  def initialize
    @gameboard = Board.new
    @gameboard.display_board
  end

  def play
    turns = 0

  end

  def update_board

  end
end

class Tile
  attr_accessor :bombed, :neighbors_locs

  def initialize(loc)
    @loc = loc
    @bombed = false
    @flagged = false
    @revealed = false
    #self.neighbors
  end

  def inspect
    if @bombed
      return "*"
    elsif @flagged
      return "F"
    elsif @revealed
      return "R"
    else
      return "*"
    end
  end

  def reveal
    puts "\nChoose a location"
    loc = gets.chomp
    x = Integer(loc.split(' ')[0])
    y = Integer(loc.split(' ')[1])
    return [x,y]
  end

  def generate_neighbors
    x = @loc[0]
    y = @loc[1]
    @neighbors = [[x - 1, y], [x + 1, y],
                       [x, y - 1], [x, y + 1],
                       [x - 1, y + 1], [x - 1, y - 1],
                       [x + 1, y + 1], [x + 1, y - 1]]
    @neighbors.select! do |x, y|
      x >= 0 && x < ROWS && y >= 0 &&  y < COLUMNS
    end
  end

  def neighbors
    @neighbors
  end

  def neighbor_bomb_count

  end

end

class Board

  def make_board
    @board = []
    COLUMNS.times {@board << []}
    @board.each do |column|
      ROWS.times {column << Tile.new(loc)}
    end
  end

  def place_bombs
    @bomb_locs = []
    bombs_placed = 0
    until bombs_placed == BOMBS
      x = rand(0...ROWS)
      y = rand(0...COLUMNS)
      loc = [x,y]
      unless @bomb_locs.include?(loc)
        p [x,y]
        p @board[x][y].bombed = true
        p @board[x][y]
        @bomb_locs << loc
        bombs_placed += 1
      end
    end
  end

  def initialize
    self.make_board
    self.place_bombs
  end

  def display_board
    puts "   0  1  2  3  4  5  6  7  8"
    i = 0
    @board.each do |row|
      puts "#{i} #{row}"
      i += 1
    end
  end
end

x = Minesweeper.new

# if __FILE__ == $PROGRAM_NAME
#    Minesweeper.new
# end