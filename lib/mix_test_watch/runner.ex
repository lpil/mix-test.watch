defmodule MixTestWatch.Runner do
  @moduledoc false

  alias MixTestWatch.Config

  #
  # Behaviour specification
  #

  @callback run(Config.t) :: :ok


  #
  # Public API
  #

  @doc """
  Run tests using the runner from the config.
  """
  def run(%Config{} = config) do
    :ok = maybe_clear_terminal(config)
    IO.puts "\nRunning tests..."
    :ok = maybe_print_timestamp(config)
    :ok = config.runner.run(config)
    :ok
  end

  @doc """
  Run the setup tasks prior to running the real tests
  """
  def run_once(%Config{} = config) do
    IO.puts "\nRunning setup_tasks (just once)..."
    :ok = config.runner.run(config |> Map.put(:tasks, config.setup_tasks))
    :ok
  end

  #
  # Internal functions
  #

  defp maybe_clear_terminal(%{clear: false}),
    do: :ok
  defp maybe_clear_terminal(%{clear: true}),
    do: :ok = IO.puts(IO.ANSI.clear <> IO.ANSI.home)

  defp maybe_print_timestamp(%{timestamp: false}),
    do: :ok
  defp maybe_print_timestamp(%{timestamp: true}) do
    :ok =
      DateTime.utc_now
      |> DateTime.to_string
      |> IO.puts
  end
end
