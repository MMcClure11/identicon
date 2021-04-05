# Identicon

**TODO: Add description**
- The application allows a user to create identicons based on a string that they input.
- The flow of the app is as follows:
    - Take in a string
    - Compute the MD5 hash of the string
    - Create a list of numberes based on the string
    - Create an RGB color based on the first three numbers
    - Build a grid of squares
    - Convert the grid into an image
    - Save the image as a png file

## To Run

    $ iex -S mix
    $ Identicon.main("string")
    Where "string" is the series of characters you want turned into an identicon.
    In a new terminal in the Identicon directory you can run
    $ open string.png
    and it will reveal the created identicon.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `identicon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:identicon, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/identicon](https://hexdocs.pm/identicon).

