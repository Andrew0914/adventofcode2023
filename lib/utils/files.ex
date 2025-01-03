defmodule Utils.Files do
  def read_file(file_path) do
    File.read!(file_path)
  end

  def get_lines(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end

  def is_digit?(item) when is_nil(item) do
    false
  end
end
