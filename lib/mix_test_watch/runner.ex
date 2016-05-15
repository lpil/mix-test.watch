defmodule MixTestWatch.Runner do
  @moduledoc false

  alias MixTestWatch, as: MTW
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
    :ok = config.runner.run(config)
    :ok
  end

  @doc """
  Run tests using the runner from the config if the file is a watched file.
  """
  def run(path, %Config{} = config) do
    if MTW.Path.watching?(path, config) do
      :ok = MTW.Runner.run(config)
    else
      :ok
    end
  end


  #
  # Internal functions
  #

  defp maybe_clear_terminal(%{clear: false}),
    do: :ok
  defp maybe_clear_terminal(%{clear: true}),
    do: :ok = IO.puts(IO.ANSI.clear <> IO.ANSI.home)
end
