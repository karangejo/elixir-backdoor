defmodule BackdoorTest do
  use ExUnit.Case
  doctest Backdoor

  test "greets the world" do
    assert Backdoor.hello() == :world
  end
end
