defmodule MixTestWatch.Command do
  @moduledoc """
  Responsible for forming our shell commands.
  """

  alias MixTestWatch.Config

  @spec build(%Config{}) :: String.t

  @doc """
  Builds the shell command that runs the desired mix task(s).
  """
  def build(config) do
    command =
      config.tasks
      |> Enum.map(&task_command(&1, config))
      |> Enum.join(" && ")
    ~s(sh -c "#{command}")
  end


  defp task_command(task, config) do
    ["MIX_ENV=test", config.prefix, "do", ansi <> ",", task, config.cli_args]
    |> Enum.filter(&(&1))
    |> Enum.join(" ")
  end


  @spec ansi :: String.t
  defp ansi do
    "run -e 'Application.put_env(:elixir, :ansi_enabled, true);'"
  end
end
