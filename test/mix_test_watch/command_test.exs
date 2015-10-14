defmodule MixTestWatch.CommandTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias MixTestWatch.Command

  test "build returns a sensible default command" do
    expected = ~s(sh -c "MIX_ENV=test mix do run -e )
            <> "'Application.put_env(:elixir, :ansi_enabled, true);'"
            <> ~s(, test ")
    assert Command.build == expected
  end

  test "build passes arguments to the test task" do
    assert "Hi there" |> Command.build |> String.ends_with?(~s(test Hi there"))
  end

  test "exec runs a given command, streaming to STDOUT" do
    printed = capture_io fn->
      Command.exec "echo Hello, world!"
    end
    assert printed == "Hello, world!\n"
  end
end
