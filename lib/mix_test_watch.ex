defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  def run(_) do
    {:ok, agent} = Agent.start_link(
      fn -> true end, name: :mix_test_watch_state
    )
    Application.start :fs
    GenServer.start_link( __MODULE__, [], name: __MODULE__ )
    :timer.sleep :infinity
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
    Agent.get( :mix_test_watch_state, fn x -> x end )
  end

  defp watching?(path) do
    Regex.match?( ~r/\.exs?\z/i, path )
  end

  defp run_tests do
    IO.puts "Running tests..."
    Agent.update( :mix_test_watch_state, fn _ -> false end )
    IO.puts( to_string :os.cmd(mix_cmd) )
    Agent.update( :mix_test_watch_state, fn _ -> true end )
  end

  defp mix_cmd do
    enable_ansi = "Application.put_env(:elixir, :ansi_enabled, true);"
    set_mix_env = ~S[System.put_env("MIX_ENV", "test");]
    to_char_list  ~s[mix do run -e '#{enable_ansi} #{set_mix_env}', test]
  end
end
