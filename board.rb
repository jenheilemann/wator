require './entities'

DIRECTIONS ={
  north: 0,
  east: 1,
  south: 2,
  west: 3
}

class Board
  def initialize board, env
    @height = board[:height]
    @width = board[:width]
    @env = env
    create_initial_state
  end

  def tick
    @vertebrates = @grid.values.select {|v| v.class != Water }
    @vertebrates.each do |entity|
      entity.tick
    end
    puts "vertebrates: " + @vertebrates.length.to_s
    puts "Grid: " + @grid.values.select {|v| v.class != Water }.length.to_s
  end

  def state
    string = ""
    @height.times do |y|
      @width.times do |x|
        string << @grid[[x, y]].to_s
      end
      string << "\n"
    end
    string
  end

  def open_neighbors(x,y)
    empty = []
    if (x != 0 && @grid[[x-1, y]].is_water?) ||
       (x == 0 && @grid[[@width-1, y]].is_water?)
      empty << DIRECTIONS[:west]
    end

    if (x != @width-1 && @grid[[x+1, y]].is_water?) ||
       (x == @width-1 && @grid[[0, y]].is_water?)
      empty << DIRECTIONS[:east]
    end

    if (y != 0 && @grid[[x, y-1]].is_water?) ||
       (y == 0 && @grid[[x, @height-1]].is_water?)
      empty << DIRECTIONS[:north]
    end

    if (y != @height-1 && @grid[[x, y+1]].is_water?) ||
       (y == @height-1 && @grid[[x, 0]].is_water?)
      empty << DIRECTIONS[:south]
    end
    empty
  end

  def fishes_near(x,y)
    fishes = []

    if (x != 0 && @grid[[x-1, y]].is_fish?) ||
       (x == 0 && @grid[[@width-1, y]].is_fish?)
      fishes << DIRECTIONS[:west]
    end

    if (x != @width-1 && @grid[[x+1, y]].is_fish?) ||
       (x == @width-1 && @grid[[0, y]].is_fish?)
      fishes << DIRECTIONS[:east]
    end

    if (y != 0 && @grid[[x, y-1]].is_fish?) ||
       (y == 0 && @grid[[x, @height-1]].is_fish?)
      fishes << DIRECTIONS[:north]
    end

    if (y != @height-1 && @grid[[x, y+1]].is_fish?) ||
       (y == @height-1 && @grid[[x, 0]].is_fish?)
      fishes << DIRECTIONS[:south]
    end
    fishes
  end

  def move(entity, direction)
    x, y = entity.x, entity.y
    @grid[[x, y]] = Water.new({x: x, y: y}, self)

    case direction
      when DIRECTIONS[:west]
        x = @width if (x == 0)
        @grid[[x-1, y]] = entity
        return x-1, y
      when DIRECTIONS[:east]
        x = -1 if (x == @width-1)
        @grid[[x+1, y]] = entity
        return x+1, y
      when DIRECTIONS[:north]
        y = @height if (y == 0)
        @grid[[x, y-1]] = entity
        return x, y-1
      when DIRECTIONS[:south]
        y = -1 if (y == @height-1)
        @grid[[x, y+1]] = entity
        return x, y+1
    end
  end

  def eat(x, y)
    eaten = @vertebrates.first { |v| v.is_fish? && v.x == x && v.y == y }
    puts "eaten: #{eaten.class} #{@vertebrates.delete(eaten){"Not found!!!!!!!"}}"
    # @vertebrates.delete(eaten)
  end

  def kill(entity)
    x, y = entity.x, entity.y
    @grid[[x, y]] = Water.new({x: x, y: y}, self)
    puts "kill: #{entity.class} #{@vertebrates.delete(entity){ "NOT FoUND!  ! !"}}"
    # @vertebrates.delete(entity)
  end

  def populate(klass, x, y)
    # puts "populate: #{klass} x:#{x} y:#{y}"
    @grid[[x, y]] = klass.new({x: x, y: y}, self)
    @vertebrates << @grid[[x, y]]
    # puts "#{@grid[[x, y]]} #{@grid[[x, y]].class} #{@grid[[x, y]].x} #{@grid[[x, y]].y}"
  end

private
  def create_initial_state
    @grid = {}
    @vertebrates = []

    @width.times do |x|
      @height.times do |y|
        @grid[[x, y]] = Water.new({x: x, y: y}, self)
      end
    end

    fish_counter = 0
    until fish_counter == @env[:starting_fish] do
      x = rand(@width)
      y = rand(@height)
      if @grid[[x,y]].is_water?
        @grid[[x,y]] = Fish.new({x: x, y: y,}, self)
        @vertebrates << @grid[[x,y]]
        fish_counter += 1
      end
    end

    shark_counter = 0
    until shark_counter == @env[:starting_sharks] do
      x = rand(@width)
      y = rand(@height)
      if @grid[[x,y]].is_water?
        @grid[[x,y]] = Shark.new({x: x, y: y}, self)
        @vertebrates << @grid[[x,y]]
        shark_counter += 1
      end
    end
  end
end
