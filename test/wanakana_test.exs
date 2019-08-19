defmodule WanakanaTest do
  use ExUnit.Case
  doctest Wanakana

  test "greets the world" do
    assert Wanakana.hello() == :world
  end
end
