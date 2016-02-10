defmodule MixTestWatch.CommandTest do
  use ExUnit.Case, async: false
  use TemporaryEnv

  alias MixTestWatch.Command

  test "build appends commandline arguments" do
    args = "test/mix_test_watch/command_test.exs:15"
    expected = ~s(sh -c "MIX_ENV=test mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, test test/mix_test_watch/command_test.exs:15")
    TemporaryEnv.delete :mix_test_watch, :tasks do
      assert Command.build(args) == expected
    end
  end

  test "build returns a sensible default command" do
    expected = ~s(sh -c "MIX_ENV=test mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, test")
    TemporaryEnv.delete :mix_test_watch, :tasks do
      assert Command.build == expected
    end
  end

  test "build can take tasks from application env" do
    tasks = ["dogma do something"]
    expected = ~s(sh -c "MIX_ENV=test mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, dogma do something")
    TemporaryEnv.set :mix_test_watch, tasks: tasks do
      assert Command.build == expected
    end
  end

  test "build can take command prefixes from application env" do
    prefix = ["iex -S mix"]
    expected = ~s[sh -c "MIX_ENV=test iex -S mix do run -e ]
            <> ~s['Application.put_env(:elixir, :ansi_enabled, true);', test"]
    TemporaryEnv.delete :mix_test_watch, :tasks do
        TemporaryEnv.set :mix_test_watch, prefix: prefix do
          assert Command.build == expected
        end
    end
  end
end
