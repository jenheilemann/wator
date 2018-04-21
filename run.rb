
FISH_FERTILITY_RATE = 3
SHARK_FERTILITY_RATE = 9
FISH_STARTING_ENERGY = 7
SHARK_STARTING_ENERGY = 12
SHARK_ENERGY_GAIN = 2

env = {
  starting_fish: 100,
  starting_sharks: 20,
}

tick = {
  total_ticks: 15,
  write_to_file: 1,
}

board = {
  height: 50,
  width: 75,
}

require './runner'

runner = Runner.new(tick, board, env)
runner.run
