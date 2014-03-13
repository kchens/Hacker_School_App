class Game #sets board, knows rules
  def initialize(size=40, generations=10)
    @board = Board.new(size, generations)
  end

  def spawn
    
  end

  def death
    
  end
end

class Board
  attr_reader :grid, :size, :to_die, :to_live

  def initialize(size, generations)
    @size = size
    @grid = Array.new(size) { Array.new(size)}
    @to_die = []
    @to_live = []
    fill_board
    # assign_coordinates
    seed
    display
    generation(generations)
  end

#Whenever you're looping, top-down is outer loop, left-right is inner loop, so
#"x" value will get you your cell:
#grid = @grid
#row = row
#cell = row[x]

  # def iterate
  #   @grid.each do |array|
  #     array.each do |cell|
  #       yield cell
  #     end
  #   end
  # end
  
  def loop_through
    @grid.each_with_index do |row, y|
      row.each_with_index do |col, x|
        yield x,y,row #col 
      end
    end
  end

  def fill_board
    loop_through do |x,y,row,col|
      row[x] = Cell.new
      row[x].board = self
      row[x].x = x
      row[x].y = y
    end
  end

  # def fill_board
  #   @grid.each do |array|
  #     @size.times do |i|
  #       array[i] = Cell.new.tap {|cell| cell.board = self}
  #     end
  #   end
  # end

  # def assign_coordinates
  #   @grid.each_with_index do |array, y_index|
  #     array.each_with_index do |column, x_index|
  #       column.tap do |cell|
  #         cell.y = y_index
  #         cell.x = x_index
  #       end
  #     end
  #   end
  # end

  def seed
    num = rand(1..500)
    num.times do |i|
      y = rand(1...(size)) #three dots b/c size creates Array.length-1
      x = rand(1...(size))
      @grid[y][x].tap {|cell| cell.state = cell.alive}
    end
  end

  def generation(number)
    number.times do |i|
      evaluate_cells
      tick!
      clear_stage
      display
      sleep(0.5)
    end
  end

  def display
    @grid.each do |array|
      array.each {|cell| print "#{cell.state}"}
      puts
    end
  end

  def evaluate_cells
    loop_through {|x, y, cell| cell.evaluate_neighbors}
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

  # THESE METHODS CHECK FOR EDGE CELLS
  def left_edge?
    @x == 0
  end

  def top_edge?
    @y == 0
  end

  def right_edge?
    @x == (board.size - 1)
  end

  def bottom_edge?
    @y == (board.size - 1)
  end

  def build_neighbors
    
  end


  def get_neighbors
    @neighbors << board.grid[@y][@x-1] unless left_edge? # west
    @neighbors << board.grid[@y][@x+1] unless right_edge? # east
    @neighbors << board.grid[@y-1][@x-1] unless (top_edge? || left_edge?) # northwest
    @neighbors << board.grid[@y-1][@x] unless top_edge? # north
    @neighbors << board.grid[@y-1][@x+1] unless (top_edge? || right_edge?) # northeast
    @neighbors << board.grid[@y+1][@x-1] unless (bottom_edge? || left_edge?) # southwest
    @neighbors << board.grid[@y+1][@x] unless bottom_edge? # south
    @neighbors << board.grid[@y+1][@x+1] unless (bottom_edge? || right_edge?) # southeast
    @neighbors
  end

  def evaluate_neighbors
    get_neighbors
    
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

board = Game.new