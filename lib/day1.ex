defmodule Day1 do
  @digit_words %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  defp is_digit?(item) do
    case Integer.parse(item) do
      {_, _} -> true
      _ -> false
    end
  end

  defp add_digit_from_word(index, line, bounds) do
    current_portion = String.slice(line, index, String.length(line))

    Enum.reduce(@digit_words, bounds, fn {word, digit}, new_bounds ->
      if String.starts_with?(current_portion, word), do: new_bounds ++ [digit], else: new_bounds
    end)
  end

  defp get_calibration_value(line) do
    digits =
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce([], fn {item, index}, bounds ->
        if is_digit?(item), do: bounds ++ [item], else: add_digit_from_word(index, line, bounds)
      end)

    Enum.at(digits, 0) <> Enum.at(digits, -1)
  end

  defp get_calibration(lines) do
    lines
    |> Enum.reduce(0, fn line, calibration ->
      line_calibration = get_calibration_value(line)
      calibration + String.to_integer(line_calibration)
    end)
  end

  def part1() do
    input_file = ~c"./assets/day1.txt"

    input_file
    |> FileReader.read_file()
    |> FileReader.get_lines()
    |> get_calibration()
  end

  def part2() do
    input_file = ~c"./assets/day1.txt"

    input_file
    |> FileReader.read_file()
    |> FileReader.get_lines()
    |> get_calibration()
  end
end
