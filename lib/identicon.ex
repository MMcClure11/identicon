defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  Main

  ## Examples

      iex(1)> Identicon.main("strawberry")
      :ok

  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do 
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do 
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) -> 
      :egd.filledRectangle(image, start, stop, fill) #oddity, updates the the current image, does not create a new one
    end

    :egd.render(image)
  end

  @doc """
  Iterates over all the tuples in the grid and for each tuple it creates a set of x,y coordinates for the top left and bottom right of the square to be filled in.

  Examples:
      iex> Identicon.build_pixel_map(%Identicon.Image{grid: [{30, 0}, {150, 4}]})
      %Identicon.Image{
        color: nil,
        grid: [{30, 0}, {150, 4}],
        hex: nil,
        pixel_map: [{{0, 0}, {50, 50}}, {{200, 0}, {250, 50}}]
      }
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do 
    pixel_map = Enum.map grid, fn({_code, index }) -> 
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Filters out hex codes that are odd. 
  Uses rem to calculate the remainder to return true if the hex code is divisible by 2.
  Returns the struct with the updated grid with only even hex codes.

  Examples:
      iex> Identicon.filter_odd_squares(%Identicon.Image{grid: [{30, 0}, {31, 2}, {45, 3}, {150, 4}]})
      %Identicon.Image{
        color: nil,
        grid: [{30, 0}, {150, 4}],
        hex: nil,
        pixel_map: nil
      }
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do 
    grid = Enum.filter grid, fn({hex_code, _index}) -> 
      rem(hex_code, 2) == 0 #rem calculates the remainder
    end

    %Identicon.Image{image | grid: grid}
  end
  @doc """
  Uses the hex list to build the grid.
  Enum.chunk(3) returns a list of lists where the lists are the size indicated in the second argument of chunk/2.
  Enum.map(&mirror_row/1) passes a reference to the mirror_row function.
  List.flatten turns the list of lists into a list of elements.
  Enum.with_index takes every element and turns it into a two element tuple with the second element being the index.

  Examples:
      iex(8)> Identicon.build_grid(%Identicon.Image{color: {145, 46, 200}, grid: nil, hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112], pixel_map: nil})
      %Identicon.Image{
        color: {145, 46, 200},
        grid: [ {145, 0}, {46, 1}, {200, 2}, {46, 3}, {145, 4}, 
          {3, 5}, {178, 6}, {206, 7}, {178, 8}, {3, 9}, 
          {73, 10}, {228, 11}, {165, 12}, {228, 13}, {73, 14}, 
          {65, 15}, {6, 16}, {141, 17}, {6, 18}, {65, 19}, 
          {73, 20}, {90, 21}, {181, 22}, {90, 23}, {73, 24}
        ],
        hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112],
        pixel_map: nil
      }
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do 
    grid = 
      hex
      |> Enum.chunk(3) 
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index
      
    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Creates rows where the last two elements are appended as mirrors of the first two elements.

  Examples:
      iex(1)> Identicon.mirror_row([145, 46, 200])
      [145, 46, 200, 46, 145]
  """
  def mirror_row(row) do 
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @doc """
  Uses pattern matching to return a struct with color tuple containing the first three numbers from the hex list which is used to set the RGB for color and the hex list.
  
  Examples:
      iex> Identicon.pick_color(%Identicon.Image{hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]})
      %Identicon.Image{
        color: {145, 46, 200},
        grid: nil,
        hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112],
        pixel_map: nil
      }
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do 
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Returns a struct with hex containing a list of 16 numbers ranging from 0-255 to use to assign the color for the identicon and build the grid.

  Examples:
      iex> Identicon.hash_input("asdf")
      %Identicon.Image{
        color: nil,
        grid: nil,
        hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112],
        pixel_map: nil
      }
  """
  def hash_input(input) do 
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
