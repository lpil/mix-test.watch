defmodule MixTestWatch.MessageInbox do
  @moduledoc """
  Helpers for managing process messages.
  """

  @spec flush :: :ok
  @doc """
  Clear the process inbox of all messages.
  """
  def flush do
    receive do
      _       -> flush()
      after 0 -> :ok
    end
  end
end
