defmodule MixTestWatch.Files do
  @moduledoc """
  Finds corresponding test file for any given file.
  """

  @spec find_test(String.t) :: String.t

  def find_test(impl) do
    candidate = impl
      |> String.replace("web/", "test/")
      |> String.replace("lib/", "test/")
      |> String.replace(~r/\.ex$/, "_test.exs")
    if File.exists?(candidate) do
      {:ok, candidate }
    else
      :none
    end
  end
end
