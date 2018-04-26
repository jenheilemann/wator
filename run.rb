
FISH_FERTILITY_RATE = 4
FISH_STARTING_ENERGY = 8
SHARK_FERTILITY_RATE = 8
SHARK_STARTING_ENERGY = 5
SHARK_ENERGY_GAIN = 2

env = {
  starting_fish: 300,
  starting_sharks: 40,
}

tick = {
  total_ticks: 30,
  write_to_file: 1,
}

board = {
  height: 50,
  width: 75,
}

require './runner'

runner = Runner.new(tick, board, env)
runner.run
