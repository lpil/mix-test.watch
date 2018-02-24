defmodule Mix.Tasks.HelloWorld do
  def run(_) do
    IO.puts("Hello, world!")
  end
end

defmodule MixTestWatch.GenTaskTest do
  use ExUnit.Case
  alias MixTestWatch.GenTask
  import ExUnit.CaptureIO

  test "tasks can be run multiple times" do
    io =
      capture_io(fn ->
        GenTask.run("hello_world", [])
        GenTask.run("hello_world", [])
      end)

    assert io == """
           Hello, world!
           Hello, world!
           """
  end
end
