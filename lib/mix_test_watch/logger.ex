defmodule MixTestWatch.Logger do
  @moduledoc """
  Deals with feedback to the user, per stdout for now
  """

  def info(config, message) do
    unless config.quiet do
      IO.puts(message)
    end
  end
end
