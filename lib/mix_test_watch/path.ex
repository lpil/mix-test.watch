defmodule MixTestWatch.Path do
  @moduledoc """
  Decides if we should refresh for a path.
  """

  alias MixTestWatch.Config

  @elixir_source_endings ~w(.erl .ex .exs .eex .leex .heex .xrl .yrl .hrl)
  @ignored_dirs ~w(deps/ _build/)

  #
  # Public API
  #

  @spec watching?(String.t(), MixTestWatch.Config.t()) :: boolean

  def watching?(path, config \\ Config.new()) do
    watched_directory?(path) and elixir_extension?(path, config.extra_extensions) and
      not excluded?(config, path)
  end

  #
  # Internal functions
  #

  @spec excluded?(MixTestWatch.Config.t(), String.t()) :: boolean

  defp excluded?(config, path) do
    config.exclude
    |> Enum.map(fn
      pattern when is_binary(pattern) -> pattern |> Regex.compile!() |> Regex.match?(path)
      pattern -> Regex.match?(pattern, path)
    end)
    |> Enum.any?()
  end

  defp watched_directory?(path) do
    not String.starts_with?(path, @ignored_dirs)
  end

  defp elixir_extension?(path, extra_extensions) do
    String.ends_with?(path, @elixir_source_endings ++ extra_extensions)
  end
end
