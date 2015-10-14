defmodule MixTestWatch.CommandTest do
  use ExUnit.Case, async: false

  alias MixTestWatch.Command

  test "build returns a sensible default command" do
    expected = "sh -c \"MIX_ENV=test mix do run -e "
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ", test \""
    assert Command.build == expected
  end

  test "build passes arguments to the test task" do
    assert Command.build("Hi there") |> String.ends_with?("test Hi there\"")
  end
end
