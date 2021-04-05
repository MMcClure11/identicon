# Identicon

**Description**

- Identicon allows a user to create identicons based on a string that they input.
- The flow of the app is as follows:
    - Take in a string
    - Compute the MD5 hash of the string
    - Create a list of numberes based on the string
    - Create an RGB color based on the first three numbers
    - Build a grid of squares
    - Convert the grid into an image
    - Save the image as a png file

## To Run

If you have Elixir installed on your system, you can fork and clone this GitHub repository. CD into the project directory. To be able to create an identicon you will need access to the Erlang Graphical Drawer which is included as a dependency in the mix.exs file. To add the dependency to the project run: 

    $ mix deps.get 

To create an identicon, while in the project directory run:

    $ iex -S mix

    $ Identicon.main("string")

"string" is the series of characters you want turned into an identicon.
In a new terminal in the Identicon directory you can run.

    $ open string.png

and it will bring up the png of the created identicon.

## Tests

To run the tests:

    $ mix test

## Documentation

To access the documentation from the application you first need to get the dependency:

    $ mix deps.get

Then make the docs:

    $ mix docs

CD into the newly made doc folder and open the html file:

    $ cd doc
    $ open index.html

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

