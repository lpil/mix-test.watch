defmodule Mix.Tasks.Test.Watch do
  use Mix.Task
  use GenServer

  def run(args) do
    setup(args)
    :timer.sleep :infinity
  end

  def setup(args) do
    Application.start :fs
    GenServer.start_link( __MODULE__, args, name: __MODULE__ )
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

  defp watching?(path) do
    Regex.match?( ~r/\.exs?\z/i, path )
  end

  defp run_tests(args) do
    IO.puts "\nRunning tests..."
    IO.puts( to_string :os.cmd(mix_cmd args) )
  end

  defp mix_cmd(args) do
    args = Enum.join(args, " ")
    ansi = "Application.put_env(:elixir, :ansi_enabled, true);"
    to_char_list ~s[MIX_ENV=test mix do run -e '#{ansi}', test #{args}]
  end
end
