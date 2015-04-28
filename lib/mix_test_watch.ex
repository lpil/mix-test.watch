defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  def run(args) do
    setup(args)
    :timer.sleep :infinity
  end

  def setup(args) do
    Agent.start_link(
      fn -> %{ not_running_tests?: true, args: args} end,
      name: :mix_test_watch_state
    )
    Application.start :fs
    GenServer.start_link( __MODULE__, [], name: __MODULE__ )
  end


  def init(_) do
    :fs.subscribe
    {:ok, []}
  end

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, _) do
    path = to_string path
    if watching?(path) && not_running_tests? do run_tests end
    {:noreply, []}
  end

  defp not_running_tests? do
    Agent.get( :mix_test_watch_state, fn x -> x.not_running_tests? end )
  end

  defp watching?(path) do
    Regex.match?( ~r/\.exs?\z/i, path )
  end

  defp run_tests(agent \\ :mix_test_watch_state) do
    IO.puts "Running tests..."
    args = Agent.get_and_update(
      agent, fn x -> { x.args, %{ x | not_running_tests?: false } } end
    )

    project = Mix.Project.config
    test_paths = project[:test_paths] || ["test"]

    test_files = Mix.Utils.extract_files(test_paths, "*") |> Enum.map(&Path.expand/1)
    # to force recompilation of test modules, we need to unload files on code_server
    :elixir_code_server.cast({:unload_files, test_files})

    Mix.Tasks.Test.run(args)
    # As the configuration will grow indefinitly, we cut it after each run
    :elixir_config.put(:at_exit, [])

    Agent.update( agent, fn x -> %{ x | not_running_tests?: true } end )
  end
end
