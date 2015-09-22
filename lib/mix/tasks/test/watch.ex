defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  @shortdoc "Automatically run tests on file changes"

  @moduledoc """
  A task for running tests whenever source files change.
  """
  def run(args) do
    args = Enum.join(args, " ")
    Application.start :fs, :permanent
    GenServer.start_link( __MODULE__, args, name: __MODULE__ )
    run_tests
    :timer.sleep :infinity
  end


  # Genserver callbacks

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



  defp watching?(path) do
    Regex.match?( ~r/\.(ex|exs|eex)\z/i, path )
  end

  defp run_tests(args \\ "") do
    IO.puts "\nRunning tests..."
    args |> mix_cmd |> shell_exec
    flush
  end

  defp mix_cmd(args) do
    ansi = "Application.put_env(:elixir, :ansi_enabled, true);"
    """
    sh -c "MIX_ENV=test mix do run -e '#{ansi}', test #{args}"
    """
  end

  defp shell_exec(exe) do
    args = ~w(stream binary exit_status use_stdio stderr_to_stdout)a
    {:spawn, exe} |> Port.open(args) |> results_loop
  end


  defp flush do
    receive do
      _       -> flush
      after 0 -> :ok
    end
  end

  defp results_loop(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        results_loop(port)

      {^port, {:exit_status, status}} ->
        status
    end
  end
end
