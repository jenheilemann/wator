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
    @vertebrates = []
    initalize_grid
    populate_grid(env)
  end

  def tick
    initalize_grid
    @newborns = []
    @vertebrates.each do |entity|
      entity.tick(self)
    end
    @vertebrates = @vertebrates.select {|v| v.alive? } + @newborns.select {|v| v.alive? }

    # Reporting
    puts "Vertebrates: " + @vertebrates.length.to_s
    grid_verts = @grid.values.select {|v| v.class != Water }
    puts "Grid: " + grid_verts.length.to_s
    if (@vertebrates.length != grid_verts.length)
      puts "Difference: "
      diff = @vertebrates - grid_verts | grid_verts - @vertebrates
      diff.each do |v|
        newborn = @newborns.include?(v)
        puts "  - #{v} new: #{newborn}"
        puts "    in grid: #{@grid[[v.x, v.y]]}"
      end
    end
  end

  def state
    string = ""
    @height.times do |y|
      @width.times do |x|
        string << @grid[[x, y]].serialize
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
    @grid[[x, y]] = Water.new({x: x, y: y})

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
    eaten = @vertebrates.find { |v| v.is_fish? && v.x == x && v.y == y }
    eaten ||= @newborns.find {|v| v.is_fish? && v.x == x && v.y == y }
    # puts "Eaten: #{eaten}"

    # puts "eaten: #{eaten.class} #{@vertebrates.delete(eaten){"Not found!!!!!!!"}}"
    eaten.die
  end

  def kill(entity)
    @grid[[entity.x, entity.y]] = Water.new({x: entity.x, y: entity.y})
    entity.die
  end

  def populate(klass, x, y)
    baby = klass.new({x: x, y: y})
    @grid[[x, y]] = baby
    @newborns << baby
  end

private
  def initalize_grid
    @grid = {}

    @height.times do |y|
      @width.times do |x|
        creature = @vertebrates.find {|v| v.x == x && v.y == y }
        @grid[[x, y]] = creature || Water.new({x: x, y: y})
      end
    end
  end

  def populate_grid(env)
    fish_counter = 0
    until fish_counter == env[:starting_fish] do
      x = rand(@width)
      y = rand(@height)
      if @grid[[x,y]].is_water?
        @grid[[x,y]] = Fish.new({x: x, y: y,})
        @vertebrates << @grid[[x,y]]
        fish_counter += 1
      end
    end

    shark_counter = 0
    until shark_counter == env[:starting_sharks] do
      x = rand(@width)
      y = rand(@height)
      if @grid[[x,y]].is_water?
        @grid[[x,y]] = Shark.new({x: x, y: y})
        @vertebrates << @grid[[x,y]]
        shark_counter += 1
      end
    end
  end
end
