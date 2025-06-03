defmodule MixTestWatch.Runner do
  @moduledoc false

  alias MixTestWatch.Config
  
  @clear_ansi_escape_sequence "\x1bc"

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
  defp maybe_clear_terminal(%{clear: true}), do: :ok = IO.puts(@clear_ansi_escape_sequence)

  defp maybe_print_timestamp(%{timestamp: false}), do: :ok

  defp maybe_print_timestamp(%{timestamp: true}) do
    :ok =
      DateTime.utc_now()
      |> DateTime.to_string()
      |> IO.puts()
  end
end
