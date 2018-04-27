defmodule MixTestWatch.PortRunner do
  @moduledoc """
  Run the tasks in a new OS process via ports
  """

  alias MixTestWatch.Config

  @doc """
  Run tests using the runner from the config.
  """
  def run(%Config{} = config) do
    {command, args} = build_tasks_cmds(:os.type(), config)
    System.cmd(command, args, into: IO.stream(:stdio, :line))

    :ok
  end

  @doc """
  Build a shell command that runs the desired mix task(s).

  Colour is forced on- normally Elixir would not print ANSI colours while
  running inside a port.
  """
  def build_tasks_cmds(os_type, config = %Config{}) do
    {
      command_for(os_type),
      [
        command_switch_for(os_type),
        config.tasks
        |> Enum.map(&task_command(os_type, &1, config))
        |> Enum.join(" && ")
      ]
    }
  end

  defp command_for({:win32, _}), do: "cmd"
  defp command_for(_os_type), do: "sh"

  defp command_switch_for({:win32, _}), do: "/c"
  defp command_switch_for(_os_type), do: "-c"

  defp set_mix_env_for({:win32, _}), do: "set MIX_ENV=test&&"
  defp set_mix_env_for(_os_type), do: "MIX_ENV=test"

  @ansi "run --no-start -e 'Application.put_env(:elixir, :ansi_enabled, true);'"

  defp ansi_command() do
    if IO.ANSI.enabled?(), do: "do #{@ansi},"
  end

  defp task_command(os_type, task, config) do
    [
      set_mix_env_for(os_type),
      config.cli_executable,
      ansi_command(),
      task
    ] ++ config.cli_args
    |> Enum.filter(& &1)
    |> Enum.join(" ")
  end
end
