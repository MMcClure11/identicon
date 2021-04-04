defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  test "main makes an identicon" do
    assert Identicon.main("hello") == :ok
  end
end
