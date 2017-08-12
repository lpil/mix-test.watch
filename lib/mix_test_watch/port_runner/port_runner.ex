defmodule MixTestWatch.PortRunner do
  @moduledoc """
  Run the tasks in a new OS process via ports
  """

  alias MixTestWatch.Config

  @doc """
  Run tests using the runner from the config.
  """
  def run(%Config{} = config) do
    command = build_tasks_cmds(config)
    case (:os.type()) do
      {:win32, _} -> System.cmd("cmd",
                                ["/C", "set MIX_ENV=test&& mix test"],
                                into: IO.stream(:stdio, :line))
      _ -> System.cmd("sh", ["-c", command], into: IO.stream(:stdio, :line))
    end
    :ok
  end


  @doc """
  Build a shell command that runs the desired mix task(s).

  Colour is forced on- normally Elixir would not print ANSI colours while
  running inside a port.
  """
  def build_tasks_cmds(config = %Config{}) do
    config.tasks
    |> Enum.map(&task_command(&1, config))
    |> Enum.join(" && ")
  end


  @ansi "run -e 'Application.put_env(:elixir, :ansi_enabled, true);'"

  defp task_command(task, config) do
    args = Enum.join(config.cli_args, " ")
    [config.cli_executable, "do", @ansi <> ",", task, args]
    |> Enum.filter(&(&1))
    |> Enum.join(" ")
    |> fn(command) -> "MIX_ENV=test #{command}" end.()
    |> String.trim()
  end
end
