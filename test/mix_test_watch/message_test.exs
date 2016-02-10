defmodule MixTestWatch.MessageTest do
  use ExUnit.Case
  alias MixTestWatch.Message

  test "flush clears the process inbox of messages" do
    Enum.each 1..10, &send(self(), &1)
    Message.flush
    refute_received _any_messages
  end
end
