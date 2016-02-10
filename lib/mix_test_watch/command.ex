defmodule MixTestWatch.Command do
  @moduledoc """
  Responsible for forming our shell commands.
  """

  @default_tasks ~w(test)a
  @default_prefix "mix"

  @spec build :: String.t

  @doc """
  Builds the shell command that runs the desired mix task(s).
  """
  def build(args \\ nil) do
    command =
      tasks
      |> Enum.map(&task_command(&1, args))
      |> Enum.join(" && ")
    ~s(sh -c "#{command}")
  end


  defp tasks do
    Application.get_env(:mix_test_watch, :tasks, @default_tasks)
  end

  defp prefix do
    Application.get_env(:mix_test_watch, :prefix, @default_prefix)
  end

  defp task_command(task, args) do
    ["MIX_ENV=test", prefix, "do", ansi <> ",", task, args]
    |> Enum.filter(&(&1))
    |> Enum.join(" ")
  end


  @spec ansi :: String.t
  defp ansi do
    "run -e 'Application.put_env(:elixir, :ansi_enabled, true);'"
  end
end
