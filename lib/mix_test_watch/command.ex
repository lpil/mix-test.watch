defmodule MixTestWatch.Command do
  @moduledoc """
  Responsible for forming our shell commands.
  """

  alias MixTestWatch.Config
  alias MixTestWatch.Environment, as: Env

  @spec build(%Config{}) :: String.t

  @doc """
  Builds the shell command that runs the desired mix task(s).
  """
  def build(config) do
    config.tasks
    |> Enum.map(&task_command(&1, config))
    |> Enum.join(" && ")
    |> Env.shell_launch
  end


  defp task_command(task, config) do
    [Env.set_var("MIX_ENV", "test", :chained), config.prefix, "do", ansi <> ",", task, config.cli_args]
    |> Enum.filter(&(&1))
    |> Enum.join(" ")
  end


  @spec ansi :: String.t
  defp ansi do
    put_env = Env.escaped_quote("Application.put_env(:elixir, :ansi_enabled, true);")
    "run -e " <> put_env
  end
end
