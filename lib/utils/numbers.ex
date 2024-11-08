defmodule Utils.Numbers do
  def is_digit?(item) do
    case Integer.parse(item) do
      {_, _} -> true
      _ -> false
    end
  end
end
