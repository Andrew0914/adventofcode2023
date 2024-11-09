defmodule Day4 do
  @doc """
  Parses the input and returns a list of lists of integers.

  ## Examples

    iex> Day4.parse_parties("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
    [[41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53]]
  """
  def parse_parties(card) do
    card
    |> String.split(":")
    |> Enum.at(1)
    |> String.trim()
    |> String.split("|")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn party ->
      party
      |> String.split(" ")
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def get_parties(lines) do
    lines |> Enum.map(&parse_parties/1)
  end

  @doc """
  Returns the number of matches between the card and the winning numbers.

  ## Examples

    iex> Day4.get_matches([[41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53]])
    4
  """
  def get_matches([card, winning_numbers]) do
    card
    |> Enum.filter(fn x -> Enum.member?(winning_numbers, x) end)
    |> Enum.count()
  end

  @doc """
  Returns the number of points for the card.

  #Examples

    iex> Day4.get_points(10)
    512
  """
  def get_points(winnings) do
    if winnings > 0,
      do: 2 ** (winnings - 1),
      else: 0
  end

  def part1 do
    input_file = ~c"./assets/day4.txt"

    input =
      input_file
      |> Utils.Files.read_file()

    input
    |> Utils.Files.get_lines()
    |> get_parties()
    |> Enum.map(&get_matches/1)
    |> Enum.map(&get_points/1)
    |> Enum.sum()
  end

  def get_copies(matches) do
    matches
    |> Enum.with_index()
    |> Enum.map(fn {match, index} ->
      start_card = index + 1
      end_card = min(start_card + (match - 1), length(matches) - 1)

      index_of_copied_cards = if match > 0, do: start_card..end_card |> Enum.to_list(), else: []

      copies = index_of_copied_cards |> Enum.map(&(&1 + 1))
      original = index + 1
      [original | copies]
    end)
  end

  def part2 do
    # input_file = ~c"./assets/day4.txt"

    # input =
    #   input_file
    #   |> Utils.Files.read_file()

    input = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

    input
    |> Utils.Files.get_lines()
    |> get_parties()
    |> Enum.map(&get_matches/1)
    |> get_copies()
  end
end
