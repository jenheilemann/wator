class Entity
  attr_reader :y, :x

  def initialize(args, board)
    @x = args[:x]
    @y = args[:y]
    @board = board
    @energy = args[:energy]
    @fertility = args[:fertility]
  end

  def is_water?
    false
  end

  def tick
    empty = @board.open_neighbors(@x,@y)
    if empty.length > 0
      move(empty.sample)
    end
  end

  def move(direction)
    @x, @y = @board.move(self, direction)
  end
end

# blub
class Fish < Entity
  def to_s
    "1"
  end

end

# Shark
class Shark < Entity
 def to_s
    "2"
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
