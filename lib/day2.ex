defmodule Day2 do
  @rules_set_d1 [red: 12, green: 13, blue: 14]

  def parse_game(line) when is_binary(line) do
    [game | [sets]] = String.split(line, ":")

    [_, game_index] = String.split(game, " ")

    cube_sets =
      sets
      |> String.split(";")
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(fn set ->
        [_remain, quantity, color] = String.split(set, " ")

        {String.to_atom(color), String.to_integer(quantity)}
      end)

    {String.to_integer(game_index), cube_sets}
  end

  def game_is_invalid?(cube_sets) when is_list(cube_sets) do
    cube_sets
    |> Enum.any?(fn {color, quantity} ->
      quantity > @rules_set_d1[color]
    end)
  end

  def get_sum_of_invalid_games(lines) do
    lines
    |> Enum.map(&parse_game/1)
    |> Enum.map(fn {game, cube_sets} ->
      if game_is_invalid?(cube_sets), do: 0, else: game
    end)
    |> Enum.sum()
  end

  def get_minimum_cubes({_game, cube_sets}) do
    [:blue, :red, :green]
    |> Enum.map(fn color ->
      Keyword.get_values(cube_sets, color)
      |> Enum.reduce(1, fn value, acc ->
        if value > acc, do: value, else: acc
      end)
    end)
  end

  def get_game_power(minimum_cubes) do
    minimum_cubes |> Enum.reduce(1, fn cube, acc -> cube * acc end)
  end

  def get_total_games_power(lines) do
    lines
    |> Enum.map(&parse_game/1)
    |> Enum.map(&get_minimum_cubes/1)
    |> Enum.map(&get_game_power/1)
    |> Enum.sum()
  end

  def part1() do
    input_file = ~c"./assets/day2.txt"

    input_file
    |> Utils.Files.read_file()
    |> Utils.Files.get_lines()
    |> get_sum_of_invalid_games()
  end

  def part2() do
    input_file = ~c"./assets/day2.txt"

    input_file
    |> Utils.Files.read_file()
    |> Utils.Files.get_lines()
    |> get_total_games_power()
  end
end
