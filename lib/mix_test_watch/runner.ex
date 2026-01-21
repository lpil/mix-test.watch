defmodule MixTestWatch.Runner do
  @moduledoc false

  alias MixTestWatch.Config

  #
  # Behaviour specification
  #

  @callback run(Config.t()) :: :ok

  #
  # Public API
  #

  @doc """
  Run tests using the runner from the config.
  """
  def run(%Config{} = config) do
    :ok = maybe_clear_terminal(config)
    IO.puts("\nRunning tests...")
    :ok = maybe_print_timestamp(config)
    :ok = config.runner.run(config)
    :ok
  end

  #
  # Internal functions
  #

  defp maybe_clear_terminal(%{clear: false}), do: :ok

  defp maybe_clear_terminal(%{clear: true} = config),
    do: :ok = IO.puts(IO.ANSI.clear() <> maybe_clear_scrollback(config) <> IO.ANSI.home())

  defp maybe_clear_scrollback(%{clear_scrollback: false}), do: ""
  defp maybe_clear_scrollback(%{clear_scrollback: :macos_iterm2}), do: "\e[2J\e[3J\e[H"
  defp maybe_clear_scrollback(%{clear_scrollback: :macos_terminal}), do: "\e[3J"
  defp maybe_clear_scrollback(%{clear_scrollback: binary}) when is_binary(binary), do: binary

  defp maybe_print_timestamp(%{timestamp: false}), do: :ok

  defp maybe_print_timestamp(%{timestamp: true}) do
    :ok =
      DateTime.utc_now()
      |> DateTime.to_string()
      |> IO.puts()
  end
end
