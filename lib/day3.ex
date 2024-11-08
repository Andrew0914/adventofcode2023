defmodule Day3 do
  def build_schematic_matrix(lines) do
    lines |> Enum.map(&String.graphemes/1)
  end

  defp setup_number_part(line, {part_piece, index}, acc) do
    previous_was_digit = fn -> Utils.Numbers.is_digit?(Enum.at(line, index - 1)) end

    if index > 0 and previous_was_digit.() do
      [current_part_num | positions] = Enum.at(acc, 0)

      updated_last = [current_part_num <> part_piece | positions ++ [index]]

      [_last | rest] = acc

      [updated_last] ++ rest
    else
      [[part_piece, index]] ++ acc
    end
  end

  def parse_schema_parts(line) do
    line
    |> Enum.with_index()
    |> Enum.reduce([], fn {piece, index}, acc ->
      if Utils.Numbers.is_digit?(piece) do
        setup_number_part(line, {piece, index}, acc)
      else
        acc
      end
    end)
  end

  def get_decode_posible_number_parts(lines) do
    lines |> Enum.map(&parse_schema_parts/1)
  end

  defp valid_adjacent?(element) do
    element != nil and element != "." and not Utils.Numbers.is_digit?(element)
  end

  defp has_adjacent_symbol(y_decoded_line, x_start, x_end, lines) do
    directions = [
      {0, -1},
      {0, 1},
      {-1, 0},
      {1, 0},
      {1, -1},
      {1, 1},
      {-1, -1},
      {-1, 1}
    ]

    directions
    |> Enum.any?(fn {x, y} ->
      check_line = Utils.Lists.get_element(lines, y_decoded_line + y)

      if check_line != nil do
        first_adjacent = Utils.Lists.get_element(check_line, x_start + x)

        last_adjacent = Utils.Lists.get_element(check_line, x_end + x)

        valid_adjacent?(first_adjacent) or valid_adjacent?(last_adjacent)
      else
        false
      end
    end)
  end

  defp valid_part?(part, line_index, lines) do
    [_num_part | positions] = part
    x_start = List.first(positions)
    x_end = List.last(positions)

    has_adjacent_symbol(line_index, x_start, x_end, lines)
  end

  def get_valid_number_parts(decoded_lines, lines) do
    decoded_lines
    |> Enum.with_index()
    |> Enum.filter(fn {decoded_line, _index} -> decoded_line != [] end)
    |> Enum.map(fn {decoded_line, line_index} ->
      decoded_line
      |> Enum.filter(&valid_part?(&1, line_index, lines))
    end)
  end

  def sum_number_parts(decoded_lines) do
    decoded_lines
    |> Enum.flat_map(fn line ->
      line
      |> Enum.map(fn part ->
        [num | _positions] = part
        String.to_integer(num)
      end)
    end)
    |> Enum.sum()
  end

  def part1() do
    input =
      ~c"./assets/day3.txt"
      |> Utils.Files.read_file()

    lines =
      input |> Utils.Files.get_lines() |> build_schematic_matrix()

    get_decode_posible_number_parts(lines)
    |> get_valid_number_parts(lines)
    |> sum_number_parts()
  end
end
