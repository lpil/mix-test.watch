defmodule MixTestWatch.RunnerTest do
  use ExUnit.Case, async: false
  alias MixTestWatch, as: MTW
  alias MTW.Runner
  alias MTW.Config
  import ExUnit.CaptureIO

  defmodule DummyRunner do
    def run(config) do
      Agent.get_and_update(__MODULE__, fn(data) -> {:ok, [config | data]} end)
    end
  end

  setup do
    {:ok, _} = Agent.start_link(fn -> [] end, name: DummyRunner)
    :ok
  end

  describe "run/1" do
    test "It delegates to the runner specified by the config" do
      config = %Config{ runner: DummyRunner }
      output = capture_io fn ->
        Runner.run(config)
      end
      assert Agent.get(DummyRunner, fn(x) -> x end) == [config]
      assert output == """

      Running tests...
      """
    end
  end
end
