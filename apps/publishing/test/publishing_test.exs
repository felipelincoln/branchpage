defmodule PublishingTest do
  use ExUnit.Case
  doctest Publishing

  test "greets the world" do
    assert Publishing.hello() == :world
  end
end
