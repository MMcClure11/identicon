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

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do 
    grid = Enum.filter grid, fn({code, _index}) -> 
      rem(code, 2) == 0 #rem calculates the remainder
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do 
    grid = 
      hex
      |> Enum.chunk(3) 
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index #takes every element and turns it into a two element tuple with the second element being the index
      
    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do 
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @doc """
  Returns a struct with color containing the three numbers used to set the RGB for color.
  
  Examples:
      iex(1)> hash_input = Identicon.hash_input("asdf")
      %Identicon.Image{
        color: nil,
        grid: nil,
        hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112],
        pixel_map: nil
      }
      iex(2)> color = Identicon.pick_color(hash_input)
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
      iex(1)> hash_input = Identicon.hash_input("asdf")
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
