defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  def run(args) do
    args = Enum.join(args, " ")
    Application.start :fs, :permanent
    Application.start :porcelain, :permanent
    GenServer.start_link( __MODULE__, args, name: __MODULE__ )
    :timer.sleep :infinity
  end



  def init(args) do
    :fs.subscribe
    {:ok, %{ args: args }}
  end

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, state) do
    if watching?( to_string path ) do
      run_tests( state.args )
    end
    {:noreply, state}
  end



  defp flush do
    receive do
      _       -> flush
      after 0 -> :ok
    end
  end

  defp watching?(path) do
    Regex.match?( ~r/\.e(ex|xs?)\z/i, path )
  end

  defp run_tests(args) do
    IO.puts "\nRunning tests..."
    Porcelain.shell( mix_cmd(args), out: IO.stream(:stdio, :line) )
    flush
  end

  defp mix_cmd(args) do
    ansi = "Application.put_env(:elixir, :ansi_enabled, true);"
    "MIX_ENV=test mix do run -e '#{ansi}', test #{args}"
  end
end
