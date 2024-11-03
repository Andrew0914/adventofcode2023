defmodule FileReader do
  def read_file(file_path) do
    File.read!(file_path)
  end

  def get_lines(input) do
    input
    |> String.split("\n", trim: true)
  end
end
