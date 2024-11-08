defmodule Utils.Lists do
  def get_element([head | _tail], 0) do
    head
  end

  def get_element(_list, index) when index < 0 do
    nil
  end

  def get_element(list, index) when index >= length(list) do
    nil
  end

  def get_element(list, index) do
    Enum.at(list, index)
  end
end
