defmodule MixTestWatch.CommandTest do
  use ExUnit.Case, async: false
  use TemporaryEnv

  alias MixTestWatch.Command
  alias MixTestWatch.Config

  test "build appends commandline arguments from passed config" do
    config = %Config{ cli_args: "test/mix_test_watch/command_test.exs:15" }
    expected = ~s(sh -c "MIX_ENV=test mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, test test/mix_test_watch/command_test.exs:15")
    assert Command.build(config) == expected
  end

  test "build can take tasks from application env" do
    config = %Config{ tasks: ["dogma do something"] }
    expected = ~s(sh -c "MIX_ENV=test mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, dogma do something ")
    assert Command.build(config) == expected
  end

  test "build can take the command prefix from passed config" do
    config = %Config{ prefix: "iex -S mix" }
    expected = ~s[sh -c "MIX_ENV=test iex -S mix do run -e ]
            <> ~s['Application.put_env(:elixir, :ansi_enabled, true);', test "]
    assert Command.build(config) == expected
  end
end
