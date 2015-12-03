defmodule MixTestWatch.CommandTest do
  use ExUnit.Case, async: false
  use TemporaryEnv

  import ExUnit.CaptureIO

  alias MixTestWatch.Command

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
    expected = ~s(sh -c "MIX_ENV=test iex -S mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, test && MIX_ENV=test iex -S mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, dogma")
    TemporaryEnv.set :mix_test_watch, prefix: prefix do
      assert Command.build == expected
    end
  end

  test "exec runs a given command, streaming to STDOUT" do
    printed = capture_io fn->
      Command.exec "echo Hello, world!"
    end
    assert printed == "Hello, world!\n"
  end
end
