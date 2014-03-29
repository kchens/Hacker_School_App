class Board
  attr_reader :grid, :size, :die, :live, :ruleset

  def initialize(size=40, generations=10)
    @size = size
    @grid = Array.new(size) { Array.new(size)}
    @die = []
    @live = []
    create_grid
    seed
    display
    evolve(generations)
  end

  def loop_through
    @grid.each_with_index do |row, y|
      row.each_index do |x|
        yield x, y, row
      end
    end
  end

  def create_grid
    loop_through do |x, y, row|
      row[x] = Cell.new
      row[x].board = self
      row[x].x = x
      row[x].y = y
    end

    loop_through do |x, y, row|
      row[x].find_neighbors
    end
  end

  def seed
    num = rand(1..(size*15)) 
    num.times do |i|
      y = rand(1...(@size)) 
      x = rand(1...(@size))
      cell = @grid[y][x]
      cell.state = cell.alive
    end
  end

  def display
    @grid.each do |row|
      row.each {|cell| print "#{cell.state}"}
      puts
    end
  end

  def evolve(number)
    1.upto(number) do |i|
      fated_cells
      switch_clear
      display
      puts "Generation #{i}" 
      break puts "All dead" if barren? 
      sleep(1)
    end
  end

  def fated_cells
    loop_through {|x, y, cell| cell[x].fated_neighbors}
  end

  def switch_clear 
    die.each { |cell| cell.state = cell.dead }

    live.each { |cell| cell.state = cell.alive }
    
    die.clear
    live.clear
  end

  def barren?
    loop_through do |x, y, cell| 
      return false if cell[x].alive?
    end
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

  def dead?
    @state == dead
  end

  def alive?
    @state == alive
  end

  def size
    board.size
  end

  def find_neighbors
    low_x = (@x == 0) ? 0 : @x - 1
    high_x = (x == size - 1) ? size - 1 : @x + 1

    low_y = (@y == 0) ? 0 : @y - 1
    high_y = (@y == size - 1) ? size - 1 : @y + 1

    low_y.upto(high_y) do |y|
      low_x.upto(high_x) do |x|
        @neighbors << board.grid[y][x] if (x != @x && y != @y)
      end
    end

    @neighbors
  end

  def fated_neighbors

    born_count = [3]
    stay_alive_count = [2,3]

    alive_count = @neighbors.count { |cell| cell.alive? }

    if alive?
      if !(stay_alive_count.include?(alive_count))
        board.die << self
      else
        board.live << self
      end
    end

    if dead?
      if born_count.include?(alive_count)
        board.live << self
      else
        board.die << self
      end
    end

  end    
end

board = Board.new(50, 7)