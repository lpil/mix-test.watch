defmodule MixTestWatch.Path do
  @moduledoc """
  Decides if we should refresh for a path.
  """

  @elixir_source_endings ~w(.erl .ex .exs .eex .xrl .yrl .hrl)

  @ignored_dirs ~w(
    deps/
    _build/
  )

  @spec watching?(MixTestWatch.Config.t, String.t) :: boolean

  def watching?(config \\ %{extra_extensions: []}, path) do
    watched_directory?( path )
    && elixir_extension?(path, config.extra_extensions)
  end

  @spec excluded?(MixTestWatch.Config.t, String.t) :: boolean

  def excluded?(config, path) do
    config.exclude
    |> Enum.map(fn pattern -> Regex.match?(pattern, path)  end)
    |> Enum.any?()
  end

  defp watched_directory?(path) do
    not String.starts_with?( path, @ignored_dirs )
  end

  defp elixir_extension?(path, extra_extensions) do
    String.ends_with?(path, @elixir_source_endings ++ extra_extensions)
  end
end
