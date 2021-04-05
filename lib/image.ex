defmodule Identicon.Image do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  Holds the data needed for creating an identicon.

  ## Examples

      iex(1)> %Identicon.Image{}
      %Identicon.Image{color: nil, grid: nil, hex: nil, pixel_map: nil}

  """
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end