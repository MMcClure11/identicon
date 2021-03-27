defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Identicon.hello()
      :world

  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do 
    hex
    |> Enum.chunk(3) #Enum.chunk(hex, 3)
    |> Enum.map(&mirror_row/1) #we cannot pass a reference to a function like in javascript, se we do it with the ampersand and the num of arguments it takes
  end

  def mirror_row(row) do 
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do 
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do 
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
