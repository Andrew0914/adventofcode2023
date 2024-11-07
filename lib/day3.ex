defmodule Day3 do
  def build_schematic_matrix(lines) do
    lines |> Enum.map(&String.graphemes/1)
  end

  defp setup_number_part(line, {part_piece, index}, acc) do
    previous_was_digit = fn -> CommonUtils.is_digit?(Enum.at(line, index - 1)) end

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
      if CommonUtils.is_digit?(piece) do
        setup_number_part(line, {piece, index}, acc)
      else
        acc
      end
    end)
  end

  def get_decode_posible_number_parts(lines) do
    lines |> Enum.map(&parse_schema_parts/1)
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
      y_check = y_decoded_line + y

      check_line =
        if y_check >= 0 and y_check < length(lines), do: Enum.at(lines, y_check, nil), else: nil

      if check_line != nil do
        first_adjacent =
          if x_start + x >= 0, do: check_line |> Enum.at(x_start + x, nil), else: nil

        last_adjacent = if x_end + x >= 0, do: check_line |> Enum.at(x_end + x, nil), else: nil

        (!is_nil(first_adjacent) and first_adjacent != "." and
           !CommonUtils.is_digit?(first_adjacent)) ||
          (!is_nil(last_adjacent) and last_adjacent != "." and
             !CommonUtils.is_digit?(last_adjacent))
      else
        false
      end
    end)
  end

  def get_valid_number_parts(decoded_lines, lines) do
    decoded_lines
    |> Enum.with_index()
    |> Enum.filter(fn {decoded_line, _index} -> decoded_line != [] end)
    |> Enum.map(fn {decoded_line, line_index} ->
      decoded_line
      |> Enum.filter(fn part ->
        [_num_part | postions] = part

        has_adjacent_symbol(
          line_index,
          Enum.at(postions, 0),
          Enum.at(postions, length(postions) - 1),
          lines
        )
      end)
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
      |> CommonUtils.read_file()

    lines =
      input |> CommonUtils.get_lines() |> build_schematic_matrix()

    get_decode_posible_number_parts(lines)
    |> get_valid_number_parts(lines)
    |> sum_number_parts()
  end
end
