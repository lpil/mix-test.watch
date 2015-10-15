defmodule MixTestWatch.CommandTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  alias MixTestWatch.Command

  test "build returns a sensible default command" do
    expected = ~s(sh -c "MIX_ENV=test mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, test")
    original = Application.get_env :mix_test_watch, :tasks
    try do
      Application.delete_env :mix_test_watch, :tasks
      assert Command.build == expected
    after
      Application.put_env :mix_test_watch, :tasks, original
    end
  end

  test "build can take tasks from application env" do
    expected = ~s(sh -c "MIX_ENV=test mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, dogma do something")
    original = Application.get_env :mix_test_watch, :tasks
    try do
      Application.put_env :mix_test_watch, :tasks, ["dogma do something"]
      assert Command.build == expected
    after
      Application.put_env :mix_test_watch, :tasks, original
    end
  end

  test "exec runs a given command, streaming to STDOUT" do
    printed = capture_io fn->
      Command.exec "echo Hello, world!"
    end
    assert printed == "Hello, world!\n"
  end
end
