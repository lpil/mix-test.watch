defmodule Mix.Tasks.Test.ShellTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias MixTestWatch.Shell

  test "exec runs a given command, streaming to STDOUT" do
    printed = capture_io fn->
      Shell.exec "echo Hello, world!"
    end
    assert printed == "Hello, world!\n"
  end
end
