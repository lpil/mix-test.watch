defmodule MixTestWatch.TestTaskTest do
  use ExUnit.Case, async: false
  alias MixTestWatch.TestTask
  import ExUnit.CaptureIO

  setup do
    Agent.start(fn-> 0 end, name: __MODULE__)
    on_exit(fn-> Agent.stop(__MODULE__) end)
  end

  test "the test task can be run multiple times" do
    silence(fn->
      run_helper_test()
      run_helper_test()
    end)
    times_run = Agent.get(__MODULE__, fn x -> x end)
    assert times_run == 2
  end

  test "elixir config does not grow continuously" do
    assert :elixir_config.get(:at_exit) == []
    silence(fn-> run_helper_test() end)
    assert :elixir_config.get(:at_exit) == []
  end

  defp run_helper_test do
    ["test/mix_test_watch/test_task_helper_test.exs"]
    |> TestTask.run
  end

  defp silence(fun) do
    capture_io(:stderr, fn-> capture_io(fun) end)
  end
end
