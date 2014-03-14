class Board
  attr_reader :grid, :size, :to_die, :to_live

  def initialize(size=40, generations=5)
    @size = size
    @grid = Array.new(size) { Array.new(size)}
    #@grid.each {|row| row = Array.new(size)}
    @to_die = []
    @to_live = []
    fill_board
    seed
    display
    generation(generations)
  end

  # Whenever you're looping, top-down is outer loop, left-right is inner loop, so the "x" value will get you your cell:
  # grid = @grid
  # row = row
  # cell = row[x]

  def loop_through
    @grid.each_with_index do |row, y|
      row.each_index do |x|
        yield x, y, row
      end
    end
  end

  def fill_board
    loop_through do |x, y, row|
      row[x] = Cell.new
      row[x].board = self
      row[x].x = x
      row[x].y = y
    end

  end

  def seed
    num = rand(1..500)
    1.upto(num) do |i|
      y = rand(1...(@size)) #three dots b/c size creates Array.length-1
      x = rand(1...(@size))
      cell = @grid[y][x]
      cell.state = cell.alive
      #@grid[y][x].tap {|cell| cell.state = cell.alive}
    end
  end

  def generation(number)
    number.times do |i|
      #because Cell's evaluate_neighbors no longer has get_neighbors
      loop_through do |x, y, row|
        row[x].get_neighbors
      end

      evaluate_cells
      tick!
      clear_stage
      display
      sleep(0.5)
    end
  end

  def display
    @grid.each do |row|
      row.each {|cell| print "#{cell.state}"}
      puts
    end
  end

  def evaluate_cells
    loop_through {|x, y, cell| cell[x].evaluate_neighbors}
  end

  def tick!
    to_die.each do |cell|
      cell.state = cell.dead
    end

    to_live.each do |cell|
      cell.state = cell.alive
    end
  end

  def clear_stage
    to_die.clear
    to_live.clear
  end
end

class Cell
  attr_accessor :board, :state, :x, :y
  attr_reader   :neighbors

  def initialize
    @state = dead
    @neighbors = []
  end

  def dead
    " "
  end

  def alive
    "o"
  end

  def size
    board.size
  end

  def get_neighbors
    low_x = (@x == 0) ? 0 : @x - 1
    high_x = (x == size - 1) ? size - 1 : @x + 1

    low_y = (@y == 0) ? 0 : @y - 1
    high_y = (@y == size - 1) ? size - 1 : @y + 1

    low_y.upto(high_y) do |y|
      low_x.upto(high_x) do |x|
        @neighbors << board.grid[y][x]
      end
    end

    @neighbors
  end

  def evaluate_neighbors
    #get_neighbors
    #puts "l = #{@neighbors.length}"

    neighbor_states = @neighbors.collect do |cell|
      cell.state
    end  

    case state
      when alive
        # 2 or 3 live neighbors
        if neighbor_states.count(alive) == 2 || neighbor_states.count(alive) == 3
          board.to_live << self 
        else
          # any other amount will be less than 2 or more than 3
          board.to_die << self 
        end      
      
      when dead
        if neighbor_states.count(alive) == 3 
          board.to_live << self 
        else
          board.to_die << self
        end
    end  
    neighbor_states = []
    @neighbors = []
  end
    
end

board = Board.new