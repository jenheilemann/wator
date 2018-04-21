class Entity
  attr_reader :y, :x

  def initialize(args, board)
    @x = args[:x]
    @y = args[:y]
    @board = board
    @energy = energy_rate
    @fertility = fertility_rate
  end

  def is_water?
    false
  end

  def is_fish?
    false
  end

  def ==(other)
    self.class == other.class && x == other.x && y == other.y
  end

  def tick
  end

  def move(direction)
    @x, @y = @board.move(self, direction)
  end

  def multiply(x, y)
    if @fertility <= 0
      @fertility = fertility_rate
      @board.populate(self.class, x, y)
    end
  end
end

# blub
class Fish < Entity
  def to_s
    "1"
  end

  def is_fish?
    true
  end

  def tick
    empty = @board.open_neighbors(@x,@y)
    @fertility -= 1
    if empty.length > 0
      oldx, oldy = x, y
      move(empty.sample)
      multiply(oldx, oldy)
      @energy -= 1
    end
    if @energy <= 0
      @board.kill(self)
    end
  end

  def energy_rate
    FISH_STARTING_ENERGY
  end

  def fertility_rate
    FISH_FERTILITY_RATE
  end
end

# Shark
class Shark < Entity
 def to_s
    "2"
  end

  def tick
    @fertility -= 1

    fishes = @board.fishes_near(x, y)
    if fishes.length > 0
      oldx, oldy = x, y
      move(fishes.sample)
      @board.eat(x, y)
      multiply(oldx, oldy)
      @energy += SHARK_ENERGY_GAIN
    else
      empty = @board.open_neighbors(@x,@y)
      if empty.length > 0
        oldx, oldy = x, y
        move(empty.sample)
        multiply(oldx, oldy)
        @energy -= 1
      end
    end
    if @energy <= 0
      @board.kill(self)
    end
  end

  def energy_rate
    SHARK_STARTING_ENERGY
  end

  def fertility_rate
    SHARK_FERTILITY_RATE
  end
end

# Water class
class Water < Entity
  def initialize(args, board)
    @x = args[:x]
    @y = args[:y]
    @board = board
  end

  def tick
  end

  def to_s
    "0"
  end

  def is_water?
    true
  end
end
