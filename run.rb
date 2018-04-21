
env = {
  starting_fish: 100,
  starting_sharks: 20,
  fish_fertility_rate: 3,
  shark_fertility_rate: 10,
  starting_fish_energy: 4,
  starting_shark_energy: 8,
}

tick = {
  total_ticks: 400,
  write_to_file: 5,
}

board = {
  height: 50,
  width: 75,
}

require './runner'

runner = Runner.new(tick, board, env)
runner.run
