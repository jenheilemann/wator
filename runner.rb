require './board'

class Runner
  def initialize tick, board, env
    @file_name = "JJ#{Time.now.to_i}.txt"
    @tick = tick
    @board = Board.new(board, env)
  end

  def run
    (@tick[:total_ticks] + 1).times do |tick|
      @board.tick
      if tick % @tick[:write_to_file] == 0
        write_to_file(tick, @board.state)
      end
    end
  end

  private
  def write_to_file(tick_number, board_state)
    File.open(@file_name, "a") do |f|
      f.write "Tick: #{tick_number}\n"
      f.write board_state
    end
  end
end
