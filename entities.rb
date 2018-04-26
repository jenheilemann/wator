class Entity
  attr_reader :y, :x, :id

  def initialize(args)
    @@counter ||= -1
    @@counter += 1
    @id = @@counter
    @x = args[:x]
    @y = args[:y]
    @energy = energy_rate
    @fertility = fertility_rate
    @live = true
  end

  def is_water?
    false
  end

  def to_s
    "#{self.class} #{id} x: #{x} y: #{y} energy: #{@energy} fertility: #{@fertility} live: #{@live}"
  end

  def is_fish?
    false
  end

  def die
    @live = false
    # puts "Dead: #{self}"
  end

  def alive?
    @live
  end

  def ==(other)
    self.class == other.class && x == other.x && y == other.y
  end

  def tick(board)
  end

  def move(direction, board)
    @x, @y = board.move(self, direction)
  end

  def multiply(x, y, board)
    if @fertility <= 0
      @fertility = fertility_rate
      board.populate(self.class, x, y)
    end
  end
end

# blub
class Fish < Entity
  def serialize
    "1"
  end

  def is_fish?
    true
  end

  def tick(board)
    if !alive?
      # puts "#{self} not alive! skipping tick"
      return
    end

    empty = board.open_neighbors(@x,@y)
    @fertility -= 1
    if empty.length > 0
      oldx, oldy = x, y
      move(empty.sample, board)
      multiply(oldx, oldy, board)
      @energy -= 1
    end
    if @energy <= 0
      # puts "Fish #{id} dying of old age"
      board.kill(self)
    end
  end

  def energy_rate
    FISH_STARTING_ENERGY - 1 + rand(3)
  end

  def fertility_rate
    FISH_FERTILITY_RATE - 1 + rand(3)
  end
end

# Shark
class Shark < Entity
 def serialize
    "2"
  end

  def tick(board)
    if !alive?
      # puts "#{self} not alive! skipping tick"
      return
    end

    @fertility -= 1

    fishes = board.fishes_near(x, y)
    if fishes.length > 0
      oldx, oldy = x, y
      move(fishes.sample, board)
      # puts "Shark #{id} eating at #{x}, #{y}"

      board.eat(x, y)
      multiply(oldx, oldy, board)
      # @energy += SHARK_ENERGY_GAIN
      @energy = energy_rate
    else
      empty = board.open_neighbors(@x,@y)
      if empty.length > 0
        oldx, oldy = x, y
        move(empty.sample, board)
        multiply(oldx, oldy, board)
        @energy -= 1
      end
    end
    if @energy <= 0
      # puts "Shark #{id} dying of old age"
      board.kill(self)
    end
  end

  def energy_rate
    SHARK_STARTING_ENERGY - 1 + rand(3)
  end

  def fertility_rate
    SHARK_FERTILITY_RATE - 1 + rand(3)
  end
end

# Water class
class Water < Entity
  def initialize(args)
    @x = args[:x]
    @y = args[:y]
  end

  def tick(board)
  end

  def serialize
    "0"
  end

  def is_water?
    true
  end
end
