defmodule MixTestWatch.TestTaskTest do
  use ExUnit.Case, async: false
  alias MixTestWatch.TestTask
  import ExUnit.CaptureIO

  test "the test task can be run multiple times" do
    args = ["test/mix_test_watch/test_task_helper_test.exs"]
    Agent.start(fn-> 0 end, name: __MODULE__)
    silence(fn->
      TestTask.run(args)
      TestTask.run(args)
    end)
    times_run = Agent.get(__MODULE__, fn x -> x end)
    assert times_run == 2
  end

  defp silence(fun) do
    capture_io(:stderr, fn-> capture_io(fun) end)
  end
end
