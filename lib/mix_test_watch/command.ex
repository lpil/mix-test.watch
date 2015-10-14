defmodule MixTestWatch.Command do
  @moduledoc """
  Responsible for forming our shell commands.
  """

  @spec build(String.t) :: String.t

  @doc """
  Builds the shell command that runs the desired mix task(s).
  """
  def build(args \\ "") do
    ~s(sh -c "MIX_ENV=test mix do run -e '#{ansi}', test #{args}")
  end

  defp ansi do
    "Application.put_env(:elixir, :ansi_enabled, true);"
  end
end
