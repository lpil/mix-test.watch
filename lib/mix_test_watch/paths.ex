defmodule MixTestWatch.Path do
  @moduledoc """
  Decides if we should refresh for a path.
  """

  @elixir_source_pattern ~r/\.(erl|ex|exs|eex|xrl|yrl)\z/i

  @ignored_dirs ~w(
    deps/
    _build/
  )

  @spec watching?(String.t) :: boolean

  def watching?(path) do
    watched_directory?( path ) && elixir_extension?( path )
  end


  defp watched_directory?(path) do
    not String.starts_with?( path, @ignored_dirs )
  end

  defp elixir_extension?(path) do
    @elixir_source_pattern
    |> Regex.match?( path )
  end
end
