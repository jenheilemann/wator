require './board'

class Runner
  def initialize tick, board, env
    @tick = tick
    @board = Board.new(board, env)
  end

  def run
    print 'it worked! ' + @tick[:total_ticks].to_s
  end
end
